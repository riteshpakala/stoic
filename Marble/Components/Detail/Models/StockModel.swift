//
//  StockModel.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public class StockModel {
    let searchStock: SearchStock?
    let consoleDetailPayload: ConsoleDetailPayload?
    public init(from object: StockModelObject) {
        self.searchStock = object.stock.asSearchStock
        self.consoleDetailPayload = object.asDetail
        self.sentiment = GlobalDefaults.SentimentStrength.init(rawValue: Int(object.sentimentStrength) ?? 0) ?? .low
        self.tradingDayTime = object.date
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
}
