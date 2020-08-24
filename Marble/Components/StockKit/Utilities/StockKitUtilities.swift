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
    
    public class RSI: NSObject, Codable {
        let open: Double
        let close: Double
        
        public init(open: Double, close: Double) {
            self.open = open
            self.close = close
        }
        
        static var zero: StockKitUtils.RSI {
            return .init(open: 0, close: 0.0)
        }
    }
    
    public class Features: NSObject, Codable {
        let momentum: Int
        let volatility: Double
        let dayAverage: Double
        
        public class Averages: NSObject, Codable {
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
            
            static var zero: StockKitUtils.Features.Averages {
                return .init(momentum: 0.0, volatility: 0.0, volume: 0.0, sma20: 0.0)
            }
        }
        
        public init(
            momentum: Int,
            volatility: Double,
            dayAverage: Double) {
            
            self.momentum = momentum
            self.volatility = volatility
            self.dayAverage = dayAverage
        }
        
        static var zero: StockKitUtils.Features {
            return .init(momentum: 0, volatility: 0.0, dayAverage: 0.0)
        }
    }
    
    public struct Models {
        let volatility: SVMModel
        
        public struct DataSet {
            let stock: StockData
            let open: Double
            let close: Double
            let volume: Double
            let rsi: StockKitUtils.RSI
            let features: StockKitUtils.Features
            let averages: StockKitUtils.Features.Averages
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
                return "\("close".localized.lowercased()): $\(String(round(variable*100)/100))"
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


