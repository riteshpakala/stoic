//
//  StockData.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

public class StockData: NSObject, Codable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    public static var empty: StockData {
        return .init(symbolName: "", dateData: .init(""), open: 0.0, high: 0.0, low: 0.0, close: 0.0, adjClose: 0.0, volume: 0.0)
    }
    
    func charateristic(forModelType type: StockKitModels.ModelType) -> Double {
        switch type {
        case .open:
            return open
        case .close, .none:
            return close
        case .volume:
            return volume
        case .high:
            return high
        case .low:
            return low
        }
    }
    
    var symbolName: String
    var dateData: StockDateData
    var open: Double
    var high: Double
    var low: Double
    var close: Double
    var adjClose: Double //X-Dividend
    var volume: Double
    var count: Int = 0
    var historicalData: [StockData]? = nil {
        didSet {
            guard var history = historicalData else { return }
            averages = Averages(history: history)
            history.append(self)
            updatedAverages = Averages(history: history)
        }
    }
    
    var lastStockData: StockData {
        historicalData?.sorted(
            by: {
                ($0.dateData.asDate ?? Date()).compare(($1.dateData.asDate ?? Date())) == .orderedDescending }).first ?? self
    }
    
    var rsi: RSI? = nil
    // The momentum and volatility of this stock vs last trading day
    var features: Momentum? = nil
    // The averages that "lead" to this stocks stats
    var averages: Averages? = nil
    // The averages including this stock's data
    var updatedAverages: Averages? = nil
    
    var updatedRSI: RSI {
        if let history = historicalData?.suffix(rsi?.maxRSI ?? PredictionRules().rsiMaxHistorical) {
            return RSI(
                open: StockKitUtils.calculateRsi(
                    history.map { $0.open } + [open]),
                close: StockKitUtils.calculateRsi(
                    history.map { $0.close } + [close]),
                maxRSI: rsi?.maxRSI ?? PredictionRules().rsiMaxHistorical)
        } else {
            return rsi ?? .init(open: 0.5, close: 0.5, maxRSI: rsi?.maxRSI ?? PredictionRules().rsiMaxHistorical)
        }
    }
    
    public init(
        symbolName: String,
        dateData: StockDateData,
        open: Double,
        high: Double,
        low: Double,
        close: Double,
        adjClose: Double,
        volume: Double) {
        
        self.symbolName = symbolName
        self.dateData = dateData
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.adjClose = adjClose
        self.volume = volume
    }
    
    public required convenience init?(coder: NSCoder) {
        let symbolName: String = (coder.decodeObject(forKey: "symbolName") as? String) ?? ""
        let dateData = coder.decodeObject(forKey: "dateData") as! StockDateData
        let open: Double = coder.decodeDouble(forKey: "open")
        let high: Double = coder.decodeDouble(forKey: "high")
        let low: Double = coder.decodeDouble(forKey: "low")
        let close: Double = coder.decodeDouble(forKey: "close")
        let adjClose: Double = coder.decodeDouble(forKey: "adjClose")
        let volume: Double = coder.decodeDouble(forKey: "volume")
        let historicalData = coder.decodeObject(forKey: "historicalData") as? [StockData]
        let rsi = coder.decodeObject(forKey: "rsi") as? RSI
        let features = coder.decodeObject(forKey: "features") as? Momentum
        let averages = coder.decodeObject(forKey: "averages") as? Averages
        let updatedAverages = coder.decodeObject(forKey: "updatedAverages") as? Averages

        self.init(
            symbolName: symbolName,
            dateData: dateData,
            open: open,
            high: high,
            low: low,
            close: close,
            adjClose: adjClose,
            volume: volume)

        self.historicalData = historicalData
        self.rsi = rsi
        self.features = features
        self.averages = averages
        self.updatedAverages = updatedAverages
        self.count = historicalData?.count ?? 0
    }
    
    public func encode(with coder: NSCoder){
        coder.encode(symbolName, forKey: "symbolName")
        coder.encode(dateData, forKey: "dateData")
        coder.encode(open, forKey: "open")
        coder.encode(high, forKey: "high")
        coder.encode(low, forKey: "low")
        coder.encode(close, forKey: "close")
        coder.encode(adjClose, forKey: "adjClose")
        coder.encode(volume, forKey: "volume")
        coder.encode(historicalData, forKey: "historicalData")
        coder.encode(rsi, forKey: "rsi")
        coder.encode(features, forKey: "features")
        coder.encode(averages, forKey: "averages")
        coder.encode(updatedAverages, forKey: "updatedAverages")
    }
    
    public func update(
        historicalTradingData: [StockData],
        rsiMax: Int) -> StockData {
        
        var sortedHistory = historicalTradingData.filter {
            ($0.dateData.dateComponents.month == dateData.dateComponents.month
            && $0.dateData.dateComponents.day < dateData.dateComponents.day) ||
            ($0.dateData.dateComponents.month < dateData.dateComponents.month) ||
            ($0.dateData.dateComponents.year < dateData.dateComponents.year)
            }.sorted(by: { ($0.dateData.asDate ?? Date()).compare(($1.dateData.asDate ?? Date())) == .orderedDescending })

        let cleanedHistoryForRSI = sortedHistory.enumerated().filter { $0.offset < rsiMax }.map { $0.element }
        
        if !sortedHistory.isEmpty {
            for i in 0..<sortedHistory.count-1 {
                let stock = sortedHistory[i]
                let nextStock = sortedHistory[i+1]
                
                stock.features = Momentum(prevStock: stock, nextStock: nextStock)
                
                sortedHistory[i] = stock
            }
        }
        
        if !sortedHistory.isEmpty {
            _ = sortedHistory.removeLast()
            
            for i in 0..<sortedHistory.count {
                let stock = sortedHistory[i]
                
                stock.historicalData = sortedHistory.enumerated().filter { $0.offset > i }.map { $0.element }
                
                sortedHistory[i] = stock
            }
        }
        
        if let nextStock = sortedHistory.first {
            self.features = Momentum(prevStock: self, nextStock: nextStock)
        }
        
        self.historicalData = sortedHistory
        
        if !cleanedHistoryForRSI.isEmpty {
            self.rsi = RSI(
                open: StockKitUtils.calculateRsi(
                    cleanedHistoryForRSI.map { $0.open }),
                close: StockKitUtils.calculateRsi(
                    cleanedHistoryForRSI.map { $0.close }),
                maxRSI: rsiMax)
        }
        
        count = self.historicalData?.count ?? 0
        return self
    }
    
    public var toString: String {
        let desc: String =
            """
            '''''''''''''''''''''''''''''
            open: \(open)
            high: \(high)
            low: \(low)
            close: \(close)
            adjClose: \(adjClose)
            volume: \(volume)
            '''''''''''''''''''''''''''''
            """
        return desc
    }
}
