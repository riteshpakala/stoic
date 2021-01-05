//
//  TonalService.Indicators.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation

extension TonalServiceModels {
    public struct Indicators {
        public struct PairedSecurity {
            var base: Security
            var previous: Security
            
            var volatility: Volatility {
                Volatility.init(paired: self)
            }
        }
        
        let security: Security
        let history: [Security]
        let historyPaired: [PairedSecurity]
        
        public init(_ security: Security,
                    with quote: Quote) {
            self.security = security
            let securities: [Security] = quote.securities.sortDesc
            let sortedSecurities: [Security] = securities.filter({ $0.date.compare(security.date) == .orderedDescending })
            self.history = sortedSecurities
            
            var pairings: [PairedSecurity] = []
            for i in 0..<sortedSecurities.count-1 {
                let base = sortedSecurities[i]
                let previous = sortedSecurities[i+1]
                
                pairings.append(.init(base: base, previous: previous))
            }
            self.historyPaired = pairings
        }
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
