//
//  TonalService.Indicators.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation

extension TonalServiceModels {
    public struct Indicators {
        public static let trailingDays: Int = 30
        
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
        
        let security: Security
        let history: [Security]
        let historyPaired: [PairedSecurity]
        
        public init(_ security: Security,
                    with quote: Quote) {
            self.security = security
            let securities: [Security] = quote.securities.sortDesc.filter({ security.date.compare($0.date) == .orderedDescending || security.date.compare($0.date) == .orderedSame  })
            self.history = Array(securities.prefix(Indicators.trailingDays))
            
            var pairings: [PairedSecurity] = []
            for i in 0..<securities.count-1 {
                let base = securities[i]
                let previous = securities[i+1]
                
                pairings.append(.init(base: base, previous: previous))
            }
            self.historyPaired = pairings
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
}

extension Array where Element == Security {
    var sortAsc: [Security] {
        self.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    }
    
    var sortDesc: [Security] {
        self.sorted(by: { $0.date.compare($1.date) == .orderedDescending })
    }
}
