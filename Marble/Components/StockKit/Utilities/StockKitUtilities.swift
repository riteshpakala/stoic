//
//  StockKitUtilities.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/27/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public struct StockKitUtils {
    static let inDim: Int = 8
    static let outDim: Int = 1
    
    static let Tolerance: Double = 10e-20
    public static func calculateRsi(_ closePrices: [Double]) -> Double
    {
        var sumGain: Double = 0;
        var sumLoss: Double = 0;
        for i in 1..<closePrices.count {
            let difference = closePrices[i] - closePrices[i - 1];
            if (difference >= 0)
            {
                sumGain += difference;
            }
            else
            {
                sumLoss -= difference;
            }
        }

        if (sumGain == 0) { return 0 }
        if (abs(sumLoss) < StockKitUtils.Tolerance) { return 100 }

        let relativeStrength = sumGain / sumLoss;

        return 100.0 - (100.0 / (1 + relativeStrength));
    }
    
    public struct Models {
        public static let engine: String = "david.v0.00.00"
        let david: SVMModel
        
        public struct DataSet {
            let stock: StockData
            let open: Double
            let close: Double
            let volume: Double
            let rsi: RSI
            let features: Momentum
            let averages: Averages
            let sentiment: StockSentimentData
            
            init(
                _ stock: StockData,
                _ sentiment: StockSentimentData,
                updated: Bool = false) {
                
                self.stock = stock
                self.open = (updated ? stock.open : stock.lastStockData.open)
                self.close = (updated ? stock.close : stock.lastStockData.close)
                self.volume = updated ? stock.volume : stock.lastStockData.volume
                self.rsi = (updated ? stock.updatedRSI : (stock.rsi ?? .zero))
                self.features = stock.features ?? .zero
                self.averages = (updated ? stock.updatedAverages : stock.averages) ?? .zero
                self.sentiment = sentiment
                
            }
            
            public var asArray: [Double] {
                [
                 averages.momentum,
                 averages.volatility,
                 volume / averages.volume,
                 close / averages.sma20,
                 sentiment.posAverage,
                 sentiment.negAverage,
                 sentiment.neuAverage,
                 sentiment.compoundAverage
                ]
            }
            
            public var inDim: Int {
                asArray.count
            }
            
            public var outDim: Int {
                output.count
            }
            
            public var output: [Double] {
                [stock.close]
            }
            
            static func outputLabel(_ variable: Double) -> String {
                return "\("[ close".localized.lowercased()): $\(String(round(variable*100)/100))~ ]"
            }
            
            public var description: String {
                let desc: String =
                    """
                    '''''''''''''''''''''''''''''
                    [ Stock Data Set - \(stock.dateData.asString) ]
                    \(stock.toString)
                    RSI_open: \(rsi.open)
                    RSI_close: \(rsi.close)
                    SMA_20: \(averages.sma20)
                    \(sentiment.toString)
                    Momentum: \(features.momentum)
                    - Prev_Stock_Close: \(stock.historicalData?.first?.dateData.asString ?? "⚠️") - \(stock.historicalData?.first?.close ?? 0.0)
                    Volatility: \(features.volatility)
                    Momentum_AVG: \(averages.momentum)
                    Volatility_AVG: \(averages.volatility)
                    Volume_WAVG: \(averages.volume)
                    Historical_Count: \(stock.count)
                    '''''''''''''''''''''''''''''
                    """
                return desc
            }
        }
    }
}

public class RSI: NSObject, Codable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    let open: Double
    let close: Double
    
    public init(open: Double, close: Double) {
        self.open = open
        self.close = close
    }
    
    public required convenience init?(coder: NSCoder) {
        let open: Double = coder.decodeDouble(forKey: "volatility")
        let close: Double = coder.decodeDouble(forKey: "dayAverage")

        self.init(
            open: open,
            close: close)
    }
    
    public func encode(with coder: NSCoder){
        coder.encode(open, forKey: "open")
        coder.encode(close, forKey: "close")
    }
    
    static var zero: RSI {
        return .init(open: 0, close: 0.0)
    }
}

public class Momentum: NSObject, Codable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    let momentum: Int
    let volatility: Double
    let dayAverage: Double
    
    public init(
        momentum: Int,
        volatility: Double,
        dayAverage: Double) {
        
        self.momentum = momentum
        self.volatility = volatility
        self.dayAverage = dayAverage
    }
    
    public required convenience init?(coder: NSCoder) {
        let momentum: Int = coder.decodeInteger(forKey: "momentum")
        let volatility: Double = coder.decodeDouble(forKey: "volatility")
        let dayAverage: Double = coder.decodeDouble(forKey: "dayAverage")

        self.init(
            momentum: momentum,
            volatility: volatility,
            dayAverage: dayAverage)
    }
    
    public func encode(with coder: NSCoder){
        coder.encode(momentum, forKey: "momentum")
        coder.encode(volatility, forKey: "volatility")
        coder.encode(dayAverage, forKey: "dayAverage")
    }
    
    static var zero: Momentum {
        return .init(momentum: 0, volatility: 0.0, dayAverage: 0.0)
    }
}

public class Averages: NSObject, Codable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
    let momentum: Double
    let volatility: Double
    let volume: Double
    let sma20: Double
    
    public init(
        momentum: Double,
        volatility: Double,
        volume: Double,
        sma20: Double) {
        
        self.momentum = momentum
        self.volatility = volatility
        self.volume = volume
        self.sma20 = sma20
    }
    
    public required convenience init?(coder: NSCoder) {
        let momentum: Double = coder.decodeDouble(forKey: "momentum")
        let volatility: Double = coder.decodeDouble(forKey: "volatility")
        let volume: Double = coder.decodeDouble(forKey: "volume")
        let sma20: Double = coder.decodeDouble(forKey: "sma20")

        self.init(
            momentum: momentum,
            volatility: volatility,
            volume: volume,
            sma20: sma20)
    }
    
    public func encode(with coder: NSCoder){
        coder.encode(momentum, forKey: "momentum")
        coder.encode(volatility, forKey: "volatility")
        coder.encode(volume, forKey: "volume")
        coder.encode(sma20, forKey: "sma20")
    }
    
    static var zero: Averages {
        return .init(momentum: 0.0, volatility: 0.0, volume: 0.0, sma20: 0.0)
    }
}
