//
//  StockKitUtilities.swift
//  Stoic
//
//  Created by Ritesh Pakala on 7/27/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public struct StockKitUtils {
    static let inDim: Int = 5
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
    
    public struct RSI {
        let open: Double
        let close: Double
        
        static var zero: StockKitUtils.RSI {
            return .init(open: 0, close: 0.0)
        }
    }
    
    public struct Features {
        let momentum: Int
        let volatility: Double
        
        public struct Averages {
            let momentum: Double
            let volatility: Double
            
            static var zero: StockKitUtils.Features.Averages {
                return .init(momentum: 0.0, volatility: 0.0)
            }
        }
        
        static var zero: StockKitUtils.Features {
            return .init(momentum: 0, volatility: 0.0)
        }
    }
    
    public struct Models {
        let volatility: SVMModel
        
        public struct DataSet {
            let stock: StockData
            let open: Double
            let close: Double
            let rsi: StockKitUtils.RSI
            let features: StockKitUtils.Features
            let averages: StockKitUtils.Features.Averages
            let sentiment: StockSentimentData
            init(
                _ stock: StockData,
                _ sentiment: StockSentimentData,
                updated: Bool = false) {
                self.stock = stock
                self.open = stock.open
                self.close = stock.close
                self.rsi = (updated ? stock.updatedRSI : (stock.rsi ?? .zero))
                self.features = stock.features ?? .zero
                self.averages = (updated ? stock.updatedAverages : stock.averages) ?? .zero
                self.sentiment = sentiment
            }
            
            public var asArray: [Double] {
                [averages.momentum, averages.volatility, sentiment.posAverage, sentiment.negAverage, sentiment.neuAverage]
            }
            
            public var inDim: Int {
                asArray.count
            }
            
            public var outDim: Int {
                output.count
            }
            
            public var output: [Double] {
                [Double(stock.close)]
            }
            
            static func outputLabel(_ variable: Double) -> String {
                return "Close: $\(String(round(variable*100)/100))"
            }
            
            public var description: String {
                let desc: String =
                    """
                    '''''''''''''''''''''''''''''
                    [ Stock Data Set - \(stock.dateData.asString) ]
                    \(stock.toString)
                    RSI_open: \(rsi.open)
                    RSI_close: \(rsi.close)
                    \(sentiment.toString)
                    Momentum: \(features.momentum)
                    - Prev_Stock_Close: \(stock.historicalData?.first?.dateData.asString ?? "⚠️") - \(stock.historicalData?.first?.close ?? 0.0)
                    Volatility: \(features.volatility)
                    '''''''''''''''''''''''''''''
                    """
                return desc
            }
        }
    }
}


