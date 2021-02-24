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
    var current: Double
    var securityDate: Date
    let modelDate: Date
    let dateGenerated: Date = .today
    let targetDate: Date
    let interval: SecurityInterval
    
    public init(close: Double,
                low: Double,
                high: Double,
                volume: Double,
                current: Double,
                modelDate: Date,
                targetDate: Date,
                securityDate: Date,
                interval: SecurityInterval) {
        self.close = close
        self.low = low
        self.high = high
        self.volume = volume
        self.current = current
        self.modelDate = modelDate
        self.interval = interval
        self.securityDate = securityDate
        self.targetDate = targetDate
    }
    
    var asString: String {
        """
        high: \(high)
        close: \(close)
        low: \(low)
        volume: \(volume)
        """
    }
    
    static var zero: TonalPrediction {
        .init(close: 0, low: 0, high: 0, volume: 0, current: 0, modelDate: .today, targetDate: .today, securityDate: .today, interval: .day)
    }
}

//TODO:
extension TonalPrediction {
    public struct Tone {
        public enum Decision: String {
            case wait
            case stay
            case buyRRR = "buy***"
            case buyRR = "buy**"
            case buyR = "buy*"
            case buy
            case sellRRR = "sell***"
            case sellRR = "sell**"
            case sellR = "sell*"
            case sell
            case none = "----"
        }
        
        public enum Context: String {
            case purchased
            case watching
        }
        
        let prediction: TonalPrediction
        var decision: Decision = .none
        let context: Context
        private(set) var targetDate: Date = .today
        
        let marginRRR: Double = 0.01
        let marginRR: Double = 0.008
        let marginR: Double = 0.004
        let margin: Double = 0.002
        
        public init(_ prediction: TonalPrediction,
                    context: Context = .watching) {
            self.prediction = prediction
            self.context = context
            
            self.prepare()
            self.generate()
        }
        
        public init() {
            self.prediction = .zero
            self.context = .watching
        }
        
        mutating func prepare() {
            let dateCreated = prediction.modelDate
            switch prediction.interval {
            case .day:
                targetDate = dateCreated.advanceDate(value: 1)
            case .hour:
                targetDate = dateCreated.advanceDateHourly(value: 1)
            }
        }
        
        /*
         /!\ Theoretically the most important logic in the whole app /!\
         */
        public mutating func generate() {
            //Decision logic
            let current = prediction.current
            
            let high = prediction.high
            let low = prediction.low
            
            let highMarginRRR = high*marginRRR
            let highMarginRR = high*marginRR
            let highMarginR = high*marginR
            let highMargin = high*margin
            
            let lowMarginRRR = low*marginRRR
            let lowMarginRR = low*marginRR
            let lowMarginR = low*marginR
            let lowMargin = low*margin
            
            let highMargins = [highMarginRRR, highMarginRR, highMarginR, highMargin]
            
            let lowMargins = [lowMarginRRR, lowMarginRR, lowMarginR, lowMargin]
            
            /*
                    -- sell
               + margin
             high   -- relative sell
               - margin
             
                stay
             
               + margin
             low    -- relative buy
               - margin
                    -- buy
             
             */
            
            switch context {
            case .watching:
                for marginCandidate in lowMargins {
                    let upperBound = low + marginCandidate
                    let lowerBound = low - marginCandidate
                    
                    let isWithin = current >= lowerBound && current <= upperBound
                    
                    guard isWithin else { decision = .wait; continue }
                    
                    switch marginCandidate {
                    case lowMarginRRR:
                        decision = .buyRRR
                    case lowMarginRR:
                        decision = .buyRR
                    case lowMarginR:
                        decision = .buyR
                    case lowMargin:
                        decision = .buy
                    default:
                        decision = .wait
                    }
                }
            case .purchased:
                for marginCandidate in highMargins {
                    let upperBound = high + marginCandidate
                    let lowerBound = high - marginCandidate
                    
                    let isWithin = current >= lowerBound && current <= upperBound
                    
                    guard isWithin else { decision = .stay; continue }
                    
                    switch marginCandidate {
                    case highMarginRRR:
                        decision = .sellRRR
                    case highMarginRR:
                        decision = .sellRR
                    case highMarginR:
                        decision = .sellR
                    case highMargin:
                        decision = .sell
                    default:
                        decision = .stay
                    }
                }
            }
            
            let detail: String =
                """
                \(prediction.asString)
                --------
                highRRR: \(highMarginRRR)
                highRR: \(highMarginRR)
                highR: \(highMarginR)
                high: \(highMargin)
                --------
                decision: \(decision.rawValue)
                current price: \(prediction.current)
                """
            
            GraniteLogger.info(detail, .utility, focus: true, symbol: "🌙")
            
        }
        
        public func compare(to: Double) {
            
        }
        
        public var summary: String {
            return self.decision.rawValue
        }
        
        public var detail: String {
            return "info"
        }
        
        public var goal: String {
            targetDate.asStringWithTime
        }
        
        public var accuracy: Double {
            return 0.5
        }
        
        public static var zero: TonalPrediction.Tone {
            return .init()
        }
    }
    
    public var asPurchasedTone: TonalPrediction.Tone {
        .init(self, context: .purchased)
    }
    
    public var asTone: TonalPrediction.Tone {
        .init(self)
    }
}
