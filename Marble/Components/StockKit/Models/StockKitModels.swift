//
//  StockKitModels.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/28/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
public enum StockPrediction {
    case high
    case low
    case open
    case close
}
class StockSentimentData: NSObject {
    let date: Date
    let dateAsString: String
    let dateComponents: (year: Int, month: Int, day: Int)
    let sentimentData: [VaderSentimentOutput]
    var positives: [Double] {
        return sentimentData.map { $0.pos }
    }
    var neutrals: [Double] {
        return sentimentData.map { $0.neu }
    }
    var negatives: [Double] {
        return sentimentData.map { $0.neg }
    }
    var compounds: [Double] {
        return sentimentData.map { $0.compound }
    }
    let textData: [String]
    
    var posAverage: Double {
        guard !positives.isEmpty else { return 0 }
        var sum: Double = 0.0
        for value in positives {
            sum += value
        }
        
        return sum/Double(positives.count)
    }
    
    var negAverage: Double {
        guard !negatives.isEmpty else { return 0 }
        var sum: Double = 0.0
        for value in negatives {
            sum += value
        }
        
        return sum/Double(negatives.count)
    }
    
    var neuAverage: Double {
        guard !neutrals.isEmpty else { return 0 }
        var sum: Double = 0.0
        for value in neutrals {
            sum += value
        }
        
        return sum/Double(neutrals.count)
    }
    
    var compoundAverage: Double {
        guard !compounds.isEmpty else { return 0 }
        var sum: Double = 0.0
        for value in compounds {
            sum += value
        }
        
        return sum/Double(compounds.count)
    }
    
    init(
        date: Date,
        dateAsString: String,
        dateComponents: (year: Int, month: Int, day: Int),
        sentimentData: [VaderSentimentOutput],
        textData: [String]) {
        
        self.date = date
        self.dateAsString = dateAsString
        self.dateComponents = dateComponents
        self.sentimentData = sentimentData
        self.textData = textData
    }
    
    public var toString: String {
        let desc: String =
            """
            '''''''''''''''''''''''''''''
            posAverage: \(posAverage)
            negAverage: \(negAverage)
            neuAverage: \(neuAverage)
            compoundAverage: \(compoundAverage)
            '''''''''''''''''''''''''''''
            """
        return desc
    }
    
    public static func emptyWithValues(
        positive: Double,
        negative: Double,
        neutral: Double,
        compound: Double) -> StockSentimentData {
        
        return .init(
            date: .init(),
            dateAsString: "",
            dateComponents: Date.dateComponents(.init())(),
            sentimentData: [.init(
                pos: positive,
                neg: negative,
                neu: neutral,
                compound: compound)],
            textData: [])
    }
}
class StockData: NSObject {
    var dateData: StockDateData
    var open: Double
    var high: Double
    var low: Double
    var close: Double
    var adjClose: Double
    var volume: Double
    var count: Int = 0
    var historicalData: [StockData]? = nil {
        didSet {
            guard let history = historicalData else { return }
            
            let historicalFeatures = history.map { $0.features }
            let sumOfMomentums: Double = Double(historicalFeatures.map { $0?.momentum ?? 0 }.reduce(0, +))
            let sumOfVolatilities: Double = (historicalFeatures.map { $0?.volatility ?? 0.0 }.reduce(0, +))
            
            averages = StockKitUtils.Features.Averages(
                momentum: sumOfMomentums/Double(historicalFeatures.count),
                volatility: sumOfVolatilities/Double(historicalFeatures.count))
        }
    }
    
    var rsi: StockKitUtils.RSI? = nil
    // The momentum and volatility of this stock vs last trading day
    var features: StockKitUtils.Features? = nil
    // The averages that "lead" to this stocks stats
    var averages: StockKitUtils.Features.Averages? = nil
    // The averages including this stock's data
    var updatedAverages: StockKitUtils.Features.Averages? {
        guard let thisFeature = features,
              let history = historicalData else { return nil}
        
        let historicalFeatures = history.map { $0.features }
        let sumOfMomentums: Double = Double(historicalFeatures.map { $0?.momentum ?? 0 }.reduce(0, +) + thisFeature.momentum)
        let sumOfVolatilities: Double = (historicalFeatures.map { $0?.volatility ?? 0.0 }.reduce(0, +)) + thisFeature.volatility
        
        return StockKitUtils.Features.Averages(
            momentum: sumOfMomentums/Double(historicalFeatures.count + 1),
            volatility: sumOfVolatilities/Double(historicalFeatures.count + 1))
    }
    
    
    var updatedRSI: StockKitUtils.RSI {
        if let history = historicalData {
            return StockKitUtils.RSI(
                open: StockKitUtils.calculateRsi(
                    history.map { $0.open } + [open]),
                close: StockKitUtils.calculateRsi(
                    history.map { $0.close } + [close]))
        } else {
            print("{TEST} UPDATING ruh roh")
            return rsi ?? .init(open: 0.5, close: 0.5)
        }
    }
    
    init(
        dateData: StockDateData,
        open: Double,
        high: Double,
        low: Double,
        close: Double,
        adjClose: Double,
        volume: Double) {
        
        self.dateData = dateData
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.adjClose = adjClose
        self.volume = volume
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
        
        for i in 0..<sortedHistory.count-1 {
            let stock = sortedHistory[i]
            let nextStock = sortedHistory[i+1]
            
            stock.features = StockKitUtils.Features(
                momentum: stock.close > nextStock.close ? 1 : -1,
                volatility: (stock.close - nextStock.close)/nextStock.close)
            
            sortedHistory[i] = stock
        }
        
        _ = sortedHistory.removeLast()
        
        for i in 0..<sortedHistory.count {
            let stock = sortedHistory[i]
            
            stock.historicalData = sortedHistory.enumerated().filter { $0.offset > i }.map { $0.element }
            
            sortedHistory[i] = stock
        }
        
        if let nextStock = sortedHistory.first {
            self.features = StockKitUtils.Features(
                momentum: self.close > nextStock.close ? 1 : -1,
                volatility: (self.close - nextStock.close)/nextStock.close)
        }
        
        self.historicalData = sortedHistory
        
        self.rsi = StockKitUtils.RSI(
            open: StockKitUtils.calculateRsi(
                cleanedHistoryForRSI.map { $0.open }),
            close: StockKitUtils.calculateRsi(
                cleanedHistoryForRSI.map { $0.close }))
        
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
class StockDateData: NSObject {
    var asString: String
    var asDate: Date?
    var isOpen: Bool
    var dateComponents: (year: Int, month: Int, day: Int)
    
    init(
        date: Date?,
        isOpen: Bool,
        dateAsString: String) {
        self.asDate = date
        self.asString = dateAsString
        self.isOpen = isOpen

        let day = Calendar.nyCalendar.component(.day, from: asDate ?? Date())
        let month = Calendar.nyCalendar.component(.month, from: asDate ?? Date())
        let year = Calendar.nyCalendar.component(.year, from: asDate ?? Date())
        
        self.dateComponents = (year, month, day)
    }
}
public struct StockSearchPayload {
    public let ticker: String
    public let companyHashtag: String
    public let companyName: String
    public let symbolHashtag: String
    public let symbolName: String
    
    public init(
        ticker: String,
        companyHashtag: String,
        companyName: String,
        symbolHashtag: String,
        symbolName: String) {
        
        self.ticker = ticker
        self.companyHashtag = companyHashtag
        self.companyName = companyName
        self.symbolHashtag = symbolHashtag
        self.symbolName = symbolName
    }
    
    func cycle(_ move: Int) -> String {
        let count = asArray.count
        
        if move%count < count {
            return self.asArray[move%count]
        } else {
            return ticker
        }
    }
    
    var asString: String {
        "\(ticker), \(companyHashtag), \(companyName), \(symbolHashtag), \(symbolName)"
    }
    
    var asArray: [String] {
        [ticker, companyHashtag, companyName, symbolHashtag, symbolName]
    }
}
