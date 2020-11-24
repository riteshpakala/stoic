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
    let oracle = TweetOracle()
    
    var csvDownloadTimer: Timer? = nil
    let csvDelay: TimeInterval = 1.2
    
    var sentimentDownloadTimer: Timer? = nil
    let sentimentDelay: TimeInterval = 1.2
    
    var hasMoved: Bool = false
    var lastTranslation: CGPoint = .zero
    @objc dynamic var newTranslation: CGPoint = .zero
    @objc dynamic var progressLabelText: String? = nil
    
    var stockData: [StockData]? = nil
    var stockSentimentData: [StockSentimentData]? = nil
    @objc dynamic var thinkPayload: ThinkPayload? = nil
    
    var searchedStock: SearchStock
    
    var stockModel: StockModel? 
    
    @objc dynamic var predictionState: String = DetailView.DetailPredictionState.preparing.rawValue
    
    var model: StockKitModels? = nil
    
    var consoleDetailPayload: ConsoleDetailPayload? = nil
    
    var predictionDidUpdate: Int = 4
    
    var modelID: String? = nil
    
    init(_ searchedStock: SearchStock, _ stockModel: StockModel?) {
        self.searchedStock = searchedStock
        self.stockModel = stockModel
        
        self.model = stockModel?.consoleDetailPayload?.model
        self.consoleDetailPayload = stockModel?.consoleDetailPayload
        self.stockData = stockModel?.consoleDetailPayload?.historicalTradingData
        self.stockSentimentData = stockModel?.consoleDetailPayload?.stockSentimentData
    }
}

extension DetailState {
    var shouldPredict: Bool {
        stockModel == nil
    }
}
