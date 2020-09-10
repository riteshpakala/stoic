//
//  StockModel.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public class StockModel: NSObject {
    let id: String
    let searchStock: SearchStock?
    let consoleDetailPayload: ConsoleDetailPayload?
    let object: StockModelObject
    public init(from object: StockModelObject) {
        self.id = object.id
        self.searchStock = object.stock.asSearchStock
        self.consoleDetailPayload = object.asDetail
        self.sentiment = GlobalDefaults.SentimentStrength.init(rawValue: Int(object.sentimentStrength)) ?? .low
        self.tradingDayTime = object.date
        self.object = object
    }
    
    public var stock: SearchStock {
        searchStock ?? SearchStock.init(exchangeName: "unknown", symbolName: "unknown", companyName: "unknown")
    }
    
    public var days: Int {
        consoleDetailPayload?.days ?? 0
    }
    
    public var sentiment: GlobalDefaults.SentimentStrength
    
    public var tradingDay: String {
        consoleDetailPayload?.currentTradingDay ?? "unknown"
    }
    
    public var tradingDayTime: Double = 0.0
    
    public var tradingDayDate: Date {
        tradingDayTime.date()
    }
    
    public var model: SVMModel? {
        self.object.data?.model
    }
    
    
}

public class StockModelMerged: NSObject {
    let id: String
    let stock: SearchStock
    let stocks: [StockModel]
    let object: StockModelMergedObject
    
    public init(from object: StockModelMergedObject) {
        self.id = object.id
        self.stock = object.stock.asSearchStock ?? SearchStock
            .init(
                exchangeName: "unknown",
                symbolName: "unknown",
                companyName: "unknown")
        
        var stockModels: [StockModel] = []
        object.models?.forEach { item in
            if let model = item as? StockModelObject {
                stockModels.append(StockModel.init(from: model))
            }
        }
        
        self.object = object
        self.stocks = stockModels
    }
    
    func calculateCompatibleModels(from models: [StockModel], base: StockModel, isRemoving: Bool = false) -> [StockModel] {
        //First add stocks added into list
        var compatibleStocks: [StockModel] = (models + [base]).sorted(
            by: { ($0.tradingDay.asDate() ?? Date())
            .compare(($1.tradingDay.asDate() ?? Date())) == .orderedDescending })
        
        //Second remove all stocks of the same date
        let dates: [String] = compatibleStocks.map { $0.tradingDay }
        let filteredStocks: [StockModel] = self.stocks.filter { !dates.contains($0.tradingDay) }
        
        //Seperate stocks that are above and below max and min stocks with the correct
        let sortedDates = dates.sorted(by: {
                ($0.asDate() ?? Date())
                    .compare(($1.asDate() ?? Date())) == .orderedDescending })
        
        guard
            let maxDateString = sortedDates.first,
            let maxDate = maxDateString.asDate(),
            let minStock = compatibleStocks.last else {
            return compatibleStocks
        }
        
        let filteredMaxStocks: [StockModel] = filteredStocks.filter {
            
            if let date = $0.tradingDay.asDate() {
                return date.compare(maxDate) == .orderedDescending
            } else {
                return false
            }
            
        }
        
        let filteredMinStocks: [StockModel] = filteredStocks.filter {
            
            if let date = $0.tradingDay.asDate() {
                return date.compare(minStock.tradingDayDate) == .orderedAscending
            } else {
                return false
            }
            
        }
        
        //day count disparity
        
        let filteredMaxDayDisparity: [StockModel] = filteredMaxStocks.filter {
            let components = Calendar.nyCalendar.dateComponents([.day], from: $0.tradingDayDate, to: maxDate)
            
            if  let dayDiff = components.day,
                dayDiff + $0.days == 0 {

                return true
            } else {
                return false
            }
        }
        
        let filteredMinDayDisparity: [StockModel] = filteredMinStocks.filter {
            let minDate = minStock.tradingDayDate
            
            if let minDateReach = Calendar.nyCalendar.date(byAdding: .day, value: -1*minStock.days, to: minDate) {
                
                let components = Calendar.nyCalendar.dateComponents([.day], from: $0.tradingDayDate, to: minDateReach)
                
                if  components.day == 0 {
                    return true
                } else {
                    return false
                }
            } else{
                return false
            }
        }
        
        compatibleStocks.append(contentsOf: filteredMaxDayDisparity)
        compatibleStocks.append(contentsOf: filteredMinDayDisparity)
        
        
        return compatibleStocks
    }
}
