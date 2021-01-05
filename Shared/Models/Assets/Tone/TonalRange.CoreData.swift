//
//  TonalRange.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation

extension Array where Element == SecurityObject {
    var baseRange: TonalRange {
        
        let similarities: [TonalSimilarity] = self.map { TonalSimilarity.init(date: $0.date, similarity: 1.0) }
        
        let indicators: [TonalIndicators] = self.map { TonalIndicators.init(date: $0.date, volatility: 1.0, volatilityCoeffecient: 1.0) }
        
        return .init(objects: self, similarities, indicators, base: true)
    }
}
