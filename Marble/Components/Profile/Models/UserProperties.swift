//
//  UserProperties.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/24/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

class UserProperties: NSObject {
    var isPrepared: Bool = false
    let accountAge: Int
    let stockSearches: [SearchStock]
    let stockPredictions: [PredictionUpdate]
    var stockPredictionsTradingDayResults: [String: [String: StockData]] = [:]
    let stockModels: [StockModel]
    
    var uniqueTradingDaysForSymbols: [String:[String]] {
        let mapped: [[String:[String]]] = stockPredictions.compactMap {
            [$0.stock.symbolName ?? "unknown":[$0.nextTradingDay]]
        }
        
        var cleaned: [String: [String]] = [:]
        mapped.forEach { ele in
            if let first = ele.first, let value = first.value.first {

                if  cleaned.keys.contains(first.key),
                    cleaned[first.key]?.contains(value) == false {
                    cleaned[first.key]?.append(value)
                } else {
                    cleaned[first.key] = first.value
                }
            }
        }
        
        return cleaned
    }
    
    var totalUniques: Int {
        return Array(uniqueTradingDaysForSymbols.values).map({ $0.count }).reduce(0, +)
    }
    
    var totalUniquesOfResults: Int {
        return Array(stockPredictionsTradingDayResults.values).map({ $0.count }).reduce(0, +)
    }
    
    var mostSearchedStock: String {
        let symbols: [String] = stockSearches.compactMap { $0.symbolName }
        
        let counts: [String: Int] = symbols.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }
        
        return counts.sorted(by: { $0.value > $1.value }).first?.key ?? "unknown"
    }
    
    
    var deviceAverageError: Double {
        var totalPredictionErrors: Double = 0.0
        for prediction in stockPredictions {
            if let symbolName = prediction.stock.symbolName {

                if let stockData = stockPredictionsTradingDayResults[symbolName]?[prediction.nextTradingDay] {
                    totalPredictionErrors += (prediction.close - stockData.close) / stockData.close
                }
            }
        }
        
        if !stockPredictions.isEmpty {
            return totalPredictionErrors/Double(stockPredictions.count)
        } else {
            return 0.0
        }
    }
    
    public init(
        accountAge: Int,
        stockSearches: [SearchStock],
        stockPredictions: [PredictionUpdate],
        stockModels: [StockModel]) {
        
        self.accountAge = accountAge
        self.stockSearches = stockSearches
        self.stockPredictions = stockPredictions
        self.stockModels = stockModels
    }
}
