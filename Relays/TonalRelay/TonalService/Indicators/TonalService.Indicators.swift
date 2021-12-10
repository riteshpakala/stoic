//
//  TonalService.Indicators.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation

extension TonalServiceModels {
    public struct Indicators {
        public static let trailingDays: Int = 120
        
        public struct PairedSecurity {
            var base: Security
            var previous: Security
            
            var volatility: Volatility {
                Volatility.init(paired: self)
            }
            
            var toString: String {
                "Base: \(base.lastValue) // Prev: \(previous.lastValue)"
            }
        }
        
        public enum Context {
            case high
            case close
            case low
            
            public static func from(_ type: TonalModels.ModelType) -> Context {
                switch type {
                case .high:
                    return .high
                case .close:
                    return .close
                case .low:
                    return .low
                default:
                    return .close
                }
            }
        }
        
        let security: Security
        let history: [Security]
        let historyPaired: [PairedSecurity]
        let quote: Quote
        
        public init(_ security: Security,
                    with quote: Quote) {
            self.quote = quote
            self.security = security
            let securities: [Security] = quote.dailySecurities.sortDesc.filterBelow(security.date)
            self.history = Array(securities.prefix(Indicators.trailingDays))
            
            if securities.count > 1 {
                var pairings: [PairedSecurity] = []
                for i in 0..<securities.count-1 {
                    let base = securities[i]
                    let previous = securities[i+1]
                    
                    pairings.append(.init(base: base, previous: previous))
                }
                self.historyPaired = pairings
            } else {
                self.historyPaired = []
            }
        }
        
        public init(_ security: Security,
                    quote: Quote,
                    securities: [Security]) {
            self.quote = quote
            self.security = security
            let securitiesFiltered =  securities.filterBelow(security.date)
            self.history = securitiesFiltered
            
            if securitiesFiltered.count > 1 {
                var pairings: [PairedSecurity] = []
                for i in 0..<securitiesFiltered.count-1 {
                    let base = securitiesFiltered[i]
                    let previous = securitiesFiltered[i+1]
                    
                    pairings.append(.init(base: base, previous: previous))
                }
                self.historyPaired = pairings
            } else {
                self.historyPaired = []
            }
        }
        
        public init(with quote: Quote) {
            self.init(quote.latestSecurity, with: quote)
        }
    }
}

extension TonalServiceModels.Indicators {
    var basePair: PairedSecurity {
        .init(base: security, previous: historyPaired.first?.base ?? security)
    }
    
    var change: Double {
        (basePair.base.lastValue - basePair.previous.lastValue) / basePair.previous.lastValue
    }
    
    var volChange: Double {
        (basePair.base.lastValue - basePair.previous.lastValue) / basePair.previous.lastValue
    }
}

extension Security {
    public func value(forContext context: TonalServiceModels.Indicators.Context) -> Double {
        
        switch context {
        case .high:
            return highValue
        case .close:
            return lastValue
        case .low:
            return lowValue
        }
    }
}
