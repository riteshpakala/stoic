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
        
        if let securities = self.first?.quote?.securities {
            return .init(objects: self, Array(securities).expanded(from: self), similarities, indicators, base: true)
        } else {
            return .init(objects: self, self, similarities, indicators, base: true)
        }
    }
    
    func expanded(from chunk: [SecurityObject]) -> [SecurityObject] {
        let sortedChunk = chunk.sortDesc
        let ordered = self.sortDesc
        if let lastSecurity = sortedChunk.last,
           let lastSecurityIndex = ordered.firstIndex(of: lastSecurity),
           lastSecurityIndex + 1 < ordered.count {
            
            let expandedChunk = sortedChunk + [ordered[lastSecurityIndex+1]]
            
            return expandedChunk
        } else {
            return chunk
        }
    }
}

extension Date {
    func isIn(range: TonalRange) -> Bool {
        let dates = range.datesExpanded
        guard let max = dates.max(),
              let min = dates.min() else {
            return false
        }
        print("{TEST} \(max) \(min) \(self) \(min >= self && self <= max)")
        
        return min.isLessOrEqual(to: self) && max.isGreaterOrEqual(to: self)
    }
    
    func isLessOrEqual(to: Date) -> Bool {
        return to.compare(self) == .orderedDescending || self.compare(to) == .orderedSame
    }
    
    func isGreaterOrEqual(to: Date) -> Bool {
        return to.compare(self) == .orderedDescending || self.compare(to) == .orderedSame
    }
}
