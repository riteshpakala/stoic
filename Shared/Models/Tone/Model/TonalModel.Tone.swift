//
//  TonalModel.Tone.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/10/21.
//

import Foundation
import GraniteUI

public struct TonalPrediction {
    let close: Double
    let low: Double
    let high: Double
    let volume: Double
    var current: Double = 0.0
    let date: Date
    
    var asString: String {
        """
        high: \(high)
        close: \(close)
        low: \(low)
        volume: \(volume)
        """
    }
    
    static var zero: TonalPrediction {
        .init(close: 0, low: 0, high: 0, volume: 0, date: .today)
    }
}

//TODO:
extension TonalPrediction {
    public struct Tone {
        public enum Decision: String {
            case stay
            case buy
            case sell
            case none = "----"
        }
        
        let prediction: TonalPrediction
        var decision: Decision = .none
        
        public init(_ prediction: TonalPrediction) {
            self.prediction = prediction
            self.generate()
        }
        
        /*
         /!\ Theoretically the most important logic in the whole app /!\
         */
        public func generate() {
            //Decision logic
            
            let high = prediction.high
            let close = prediction.close
            let low = prediction.low
            
            
            let detail: String =
                """
                \(prediction.asString)
                --------
                current price: \(prediction.current)
                """
            
            GraniteLogger.info(detail, .utility, focus: true, symbol: "🌙")
            
        }
        
        public func compare(to: Double) {
            
        }
        
        public var summary: String {
            return self.decision.rawValue
        }
        
        public var accuracy: Double {
            return 0.5
        }
    }
    
    public var asTone: TonalPrediction.Tone {
        .init(self)
    }
}
