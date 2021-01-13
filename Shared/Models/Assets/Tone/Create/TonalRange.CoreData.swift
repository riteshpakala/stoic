//
//  TonalRange.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//
import CoreData
import Foundation

extension TonalRange {
    public func checkSentimentCache(
        _ quote: QuoteObject,
        moc: NSManagedObjectContext,
        completion: @escaping (((sentiment: TonalSentiment?, missing: TonalRange?)?) -> Void)) {
        
        let time: Double = CFAbsoluteTimeGetCurrent()
        
        moc.getSentiment(quote, self) { data in
            print("⏱⏱⏱⏱⏱⏱\n[Benchmark] Sentiment Fetch - \(CFAbsoluteTimeGetCurrent() - time) \n⏱")
            
            completion(data)
        }
    }
}

extension Array where Element == SecurityObject {
    var baseRange: TonalRange {
        
        let similarities: [TonalSimilarity] = self.map { TonalSimilarity.init(date: $0.date, similarity: 1.0) }
        
        let indicators: [TonalIndicators] = self.map { TonalIndicators.init(date: $0.date, volatility: 1.0, volatilityCoeffecient: 1.0) }
        
        if let securities = self.first?.quote?.securities {
            return .init(objects: self.asSecurities,
                         Array(securities).expanded(from: self).asSecurities,
                         similarities,
                         indicators,
                         base: true)
        } else {
            return .init(objects: self.asSecurities,
                         self.asSecurities,
                         similarities,
                         indicators,
                         base: true)
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

extension Array where Element == Security {
    func baseRange(moc: NSManagedObjectContext,
                   completion: @escaping ((TonalRange) -> Void)) {
        
        let similarities: [TonalSimilarity] = self.map { TonalSimilarity.init(date: $0.date, similarity: 1.0) }
        
        let indicators: [TonalIndicators] = self.map { TonalIndicators.init(date: $0.date, volatility: 1.0, volatilityCoeffecient: 1.0) }
        
        self.first?.getQuote(moc: moc) { quote in
            if let securities = quote?.securities {
                completion(.init(objects: self,
                             Array(securities).expanded(from: self),
                             similarities,
                             indicators,
                             base: true))
            } else {
                completion(.init(objects: self,
                             self,
                             similarities,
                             indicators,
                             base: true))
            }
        }
    }
    
    func expanded(from chunk: [Security]) -> [Security] {
        let sortedChunk = chunk.sortDesc
        let ordered = self.sortDesc
        if let lastSecurity = sortedChunk.last,
           let lastSecurityIndex = ordered.firstIndex(where: { $0.isEqual(to: lastSecurity) } ),
           lastSecurityIndex + 1 < ordered.count {
            
            let expandedChunk = sortedChunk + [ordered[lastSecurityIndex+1]]
            
            return expandedChunk
        } else {
            return chunk
        }
    }
}
