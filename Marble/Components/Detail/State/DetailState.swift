//
//  DetailState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class DetailState: State {
    let scraper = TwitterScraper()
    
    var csvDownloadTimer: Timer? = nil
    let csvDelay: TimeInterval = 1.2
    
    var sentimentDownloadTimer: Timer? = nil
    let sentimentDelay: TimeInterval = 1.2
    
    
    var lastTranslation: CGPoint = .zero
    @objc dynamic var newTranslation: CGPoint = .zero
    @objc dynamic var progressLabelText: String? = nil
    
    var stockData: [StockData]? = nil
    var stockSentimentData: [StockSentimentData]? = nil
    @objc dynamic var thinkPayload: ThinkPayload? = nil
    
    var searchedStock: SearchStock
    
    @objc dynamic var predictionState: String = DetailView.DetailPredictionState.downloadingData.rawValue
    
    var model: StockKitUtils.Models? = nil
    
    var consoleDetailPayload: ConsoleDetailPayload? = nil
    
    var predictionDidUpdate: Int = 4
    
    init(_ searchedStock: SearchStock) {
        self.searchedStock = searchedStock
    }
}

class ThinkPayload: NSObject {
    var stockSentimentData: StockSentimentData? = nil
    public init(
        sentiment: StockSentimentData) {
        self.stockSentimentData = sentiment
    }
}

class PredictionUpdate: NSObject, Codable {
    let sentimentStrength: Int
    let predictionDays: Int
    let stock: SearchStock
    let sentimentWeights: StockSentimentData
    let nextTradingDay: String
    let close: Double
    
    public init(
        sentimentStrength: Int,
        predictionDays: Int,
        stock: SearchStock,
        sentimentWeights: StockSentimentData,
        nextTradingDay: String,
        close: Double) {
        
        self.sentimentStrength = sentimentStrength
        self.predictionDays = predictionDays
        self.stock = stock
        self.sentimentWeights = sentimentWeights
        self.nextTradingDay = nextTradingDay
        self.close = close
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
        
        self.nextTradingDay = try container.decode(String.self, forKey: .nextTradingDay)
        self.close = try container.decode(Double.self, forKey: .close)
    }
    
    enum DTOKeys: String, CodingKey {
        case sentimentStrength
        case predictionDays
        case stock
        case sentimentWeights
        case nextTradingDay
        case close
        case time
    }
}
