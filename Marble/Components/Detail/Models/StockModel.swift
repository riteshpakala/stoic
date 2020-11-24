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
    private(set) var searchStock: SearchStock? = nil
    private(set) var consoleDetailPayload: ConsoleDetailPayload? = nil
    private(set) var model: StockKitModels? = nil
    private(set) var lastStock: StockData? = nil
    private(set) var firstStock: StockData? = nil
    private(set) var isMerged: Bool
    private(set) var timestamp: Double
    
    public init(from object: StockModelObject) {
        self.id = object.id
        self.searchStock = object.stock.asSearchStock
        self.consoleDetailPayload = object.asDetail
        self.sentiment = GlobalDefaults.SentimentStrength.init(rawValue: Int(object.sentimentStrength)) ?? .low
        self.tradingDayTime = object.date
        self.model = object.model?.model
        self.timestamp = object.timestamp
        let sorted = object.historicalTradingData.asStockData?.sorted(
            by: {
                ($0.dateData.asDate ?? Date()).compare(($1.dateData.asDate ?? Date())) == .orderedDescending
                
        } )
        self.lastStock = sorted?.first
        self.firstStock = sorted?.last
        self.isMerged = object.merged?.currentModels?.mergedModelIDs?.contains(object.id) == true
    }
    
    public init(fromMerged object: StockModelMergedObject) {
        self.id = object.id
        self.searchStock = object.stock.asSearchStock
        self.sentiment = nil
        self.timestamp = object.timestamp
        self.isMerged = object.merged?.currentModels?.mergedModelIDs?.contains(object.id) == true
        
        guard let models = object.models,
              let ids = object.currentModels?.mergedModelIDs else { return }
        
        let stockModelObjs: [StockModelObject] = models.compactMap({ ids.contains(($0 as? StockModelObject)?.id ?? "") ? ($0 as? StockModelObject) : nil })
        
        let sortedStockModelObjs = stockModelObjs.sorted(by: {
            ($0.date.date())
                .compare(($1.date.date())) == .orderedAscending })
        
        guard let latestModel = sortedStockModelObjs.last,
              let model = object.model?.model else { return }
        
        self.tradingDayTime = latestModel.date
        self.model = model
        
        var historical: [StockData] = []
        var sentiment: [StockSentimentData] = []
        
        
        for obj in sortedStockModelObjs {
            if let historicalData = obj.historicalTradingData.asStockData {
                historical.append(contentsOf: historicalData)
            }
            
            if let sentimentData = obj.sentimentTradingData.asStockSentimentData {
                sentiment.append(contentsOf: sentimentData)
            }
        }
        
        let predictionDays: Int = Int(sortedStockModelObjs.map({ $0.predictionDays }).reduce(0, +))
        
        self.consoleDetailPayload = .init(
            currentTradingDay: latestModel.date.date().asString,
            historicalTradingData: historical,
            stockSentimentData: sentiment,
            days: predictionDays,
            maxDays: predictionDays,
            model: model)
    }
    
    public var stock: SearchStock {
        searchStock ?? SearchStock.init(exchangeName: "unknown", symbolName: "unknown", companyName: "unknown")
    }
    
    public var days: Int {
        consoleDetailPayload?.days ?? 0
    }
    
    public var trueDays: Int {
        if let lastDate = lastStock?.dateData.asDate {
            let days = Calendar.nyCalendar.dateComponents([.day], from: lastDate, to: self.tradingDayDate)
            
            return days.day ?? 0
        } else {
            return consoleDetailPayload?.days ?? 0
        }
        
    }
    
    public var sentiment: GlobalDefaults.SentimentStrength?
    
    public var tradingDay: String {
        consoleDetailPayload?.currentTradingDay ?? "unknown"
    }
    
    public var tradingDayTime: Double = 0.0
    
    public var tradingDayDate: Date {
        tradingDayTime.date()
    }
}

public class StockModelMerged: NSObject {
    public enum Lifecycle {
        case needsSyncing
        case isStale
        case isReady
        case none
    }
    
    let id: String
    let stock: SearchStock
    private(set) var stocks: [StockModel]
    private(set) var mergedStocks: [StockModel]
    private(set) var engine: String
    
    public init(from object: StockModelMergedObject) {
        self.id = object.id
        self.stock = object.stock.asSearchStock ?? SearchStock
            .init(
                exchangeName: "unknown",
                symbolName: "unknown",
                companyName: "unknown")
        
        var stockModels: [StockModel] = []
        var stockModelsMerged: [StockModel] = []
        let mergedIDs: [String]? = object.currentModels?.mergedModelIDs
        object.models?.forEach { item in
            if let model = item as? StockModelObject {
                let modelToAdd = StockModel.init(from: model)
                stockModels.append(modelToAdd)
                
                if let ids = mergedIDs, ids.contains(model.id) {
                    stockModelsMerged.append(modelToAdd)
                }
            }
        }
        
        self.engine = object.engine
        self.stocks = stockModels
        self.mergedStocks = stockModelsMerged
    }
    
    public func update(from object: StockModelMergedObject) {
        var stockModels: [StockModel] = []
        var stockModelsMerged: [StockModel] = []
        let mergedIDs: [String]? = object.currentModels?.mergedModelIDs
        object.models?.forEach { item in
            if let model = item as? StockModelObject {
                let modelToAdd = StockModel.init(from: model)
                stockModels.append(modelToAdd)
                
                if let ids = mergedIDs, ids.contains(model.id) {
                    stockModelsMerged.append(modelToAdd)
                }
            }
        }
        
        self.engine = object.engine
        self.stocks = stockModels
        self.mergedStocks = stockModelsMerged
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
        //Above the max day in selection
        let filteredMaxDayDisparity: [StockModel] = filteredMaxStocks.filter {
            let components = Calendar.nyCalendar.dateComponents([.day], from: $0.tradingDayDate, to: maxDate)
            
            let componentsLast = Calendar.nyCalendar.dateComponents([.day], from: $0.firstStock?.dateData.asDate ?? $0.tradingDayDate, to: maxDate)
            
            if  let dayDiff = components.day,
                dayDiff + $0.trueDays == 0 {
                return true
            } else if componentsLast.day == 0 {
                return true
            } else {
                return false
            }
        }
        
        //Below the min date in selection
        let filteredMinDayDisparity: [StockModel] = filteredMinStocks.filter {
            let minDate = minStock.tradingDayDate
            
            let components = Calendar.nyCalendar.dateComponents([.day], from: $0.tradingDayDate, to: minDate)
            
            let componentsLast = Calendar.nyCalendar.dateComponents([.day], from: $0.tradingDayDate, to: minStock.lastStock?.dateData.asDate ?? minDate)
            
            if  components.day == 0 {
                return true
            } else if componentsLast.day == 0 {
                return true
            } else {
                return false
            }
        }
        
        compatibleStocks.append(contentsOf: filteredMaxDayDisparity)
        compatibleStocks.append(contentsOf: filteredMinDayDisparity)
        
        
        return compatibleStocks
    }
}

extension Array where Element == StockModel {
    var descending: [StockModel] {
        return self.sorted(by: { ($0.tradingDay.asDate() ?? Date())
            .compare(($1.tradingDay.asDate() ?? Date())) == .orderedDescending })
    }
}
