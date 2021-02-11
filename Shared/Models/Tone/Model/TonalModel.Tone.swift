//
//  TonalModel.Tone.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/10/21.
//

import Foundation

public struct TonalPrediction {
    let close: Double
    let low: Double
    let high: Double
    let volume: Double
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
        let prediction: TonalPrediction
        
        public init(_ prediction: TonalPrediction) {
            self.prediction = prediction
        }
        
        public func compare(to: Double) {
            
        }
        
        public var summary: String {
            return "sell"
        }
        
        public var accuracy: Double {
            return 0.5
        }
    }
    
    public var asTone: TonalPrediction.Tone {
        .init(self)
    }
}
