//
//  PredictionUpdate.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

class PredictionUpdate: NSObject, Codable {
    let sentimentStrength: Int
    let predictionDays: Int
    let stock: SearchStock
    let sentimentWeights: StockSentimentData
    let nextTradingDay: String
    let thisTradingDay: String
    let value: Double
    let type: String
    let id: String
    
    public init(
        sentimentStrength: Int,
        predictionDays: Int,
        stock: SearchStock,
        sentimentWeights: StockSentimentData,
        nextTradingDay: String,
        thisTradingDay: String,
        value: Double,
        type: String,
        id: String) {
        
        self.sentimentStrength = sentimentStrength
        self.predictionDays = predictionDays
        self.stock = stock
        self.sentimentWeights = sentimentWeights
        self.nextTradingDay = nextTradingDay
        self.thisTradingDay = thisTradingDay
        self.value = value
        self.type = type
        self.id = id
    }
    
    var key: String {
        return (stock.symbolName ?? "unknown")+"/"+nextTradingDay
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DTOKeys.self)
        let time = try container.decode(String.self, forKey: .time)
        
        let searchStockContainer = container.nested(forTime: time, of: .stock)
        let sentimentStockContainer = container.nested(forTime: time, of: .sentimentWeights)
        
        self.sentimentStrength = try container.decode(Int.self, forKey: .sentimentStrength)
        self.predictionDays = try container.decode(Int.self, forKey: .predictionDays)
        
        self.stock = (try? searchStockContainer?.decode(
            SearchStock.self,
            forKey: CustomCodingKey.model)) ?? SearchStock.zero
        self.sentimentWeights = (try? sentimentStockContainer?.decode(
            StockSentimentData.self,
            forKey: CustomCodingKey.model)) ?? StockSentimentData.zero
        
        let nTD = try container.decode(String.self, forKey: .nextTradingDay)
        self.nextTradingDay = nTD
        self.thisTradingDay = (try? container.decode(String.self, forKey: .thisTradingDay)) ?? nTD
        self.value = try container.decode(Double.self, forKey: .value)
        self.type = try container.decode(String.self, forKey: .type)
        self.id = (try? container.decode(String.self, forKey: .id)) ?? ""
    }
    
    enum DTOKeys: String, CodingKey {
        case sentimentStrength
        case predictionDays
        case stock
        case sentimentWeights
        case nextTradingDay
        case thisTradingDay
        case value
        case type
        case time
        case id
    }
}
