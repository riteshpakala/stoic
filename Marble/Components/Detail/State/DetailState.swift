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
    var csvDownloadTimer: Timer? = nil
    let csvDelay: TimeInterval = 1.2
    
    var sentimentDownloadTimer: Timer? = nil
    let sentimentDelay: TimeInterval = 1.2
    
    
    var lastTranslation: CGPoint = .zero
    @objc dynamic var newTranslation: CGPoint = .zero
    @objc dynamic var progressLabelText: String? = nil
    
    var stockData: [StockData]? = nil
    var stockSentimentData: [StockSentimentData]? = nil
    
    var searchedStock: SearchStock
    
    @objc dynamic var predictionState: String = DetailView.DetailPredictionState.downloadingData.rawValue
    
    var model: StockKitUtils.Models? = nil
    
    var consoleDetailPayload: ConsoleDetailPayload? = nil
    
    init(_ searchedStock: SearchStock) {
        self.searchedStock = searchedStock
    }
}
