//
//  TonalRange.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//

import Foundation
import SwiftUI

public struct TonalRange {
    let objects: [SecurityObject]
    let similarities: [TonalSimilarity]
    let indicators: [TonalIndicators]
    
    public init(
        objects: [SecurityObject],
        _ similarities: [TonalSimilarity],
        _ indicators: [TonalIndicators]) {
        
        self.objects = objects
        self.similarities = similarities
        self.indicators = indicators
    }
    
    var dates: [Date] {
        let objectDates: [Date] = objects.map { $0.date }
        return objectDates.sorted(by: { $0.compare($1) == .orderedDescending })
    }
    
    func similarity(for date: Date) -> TonalSimilarity {
        return similarities.first(where: { $0.date == date }) ?? .empty
    }
    
    func indicator(for date: Date) -> TonalIndicators {
        return indicators.first(where: { $0.date == date }) ?? .empty
    }
    
    var dateInfoShort: String {
        return "\((dates.first ?? Date.today).asString) - \((dates.last ?? Date.today).asString)"
    }
    
    var dateInfoShortDisplay: String {
        return "\((dates.first ?? Date.today).asString)\n-\n\((dates.last ?? Date.today).asString)"
    }
    
    var avgSimilarity: Double {
        return similarities.map({ $0.similarity }).reduce(0, +)/similarities.count.asDouble
    }
    
    var avgSimilarityDisplay: String {
        return "\((avgSimilarity*100).asInt)% Similar"
    }
    
    var avgSimilarityColor: Color {
        avgSimilarity > 0.6 ? Brand.Colors.green : (avgSimilarity > 0.4 ? Brand.Colors.yellow : Brand.Colors.red)
    }
}

extension TonalRange {
    var ticker: String {
        objects.first?.ticker ?? "error-ticker"
    }
}

public struct TonalSimilarity {
    let date: Date
    let similarity: Double
    
    public static var empty: TonalSimilarity {
        return .init(date: Date.today, similarity: 0.0)
    }
}

public struct TonalIndicators {
    let date: Date
    let volatility: Double
    let volatilityCoeffecient: Double
    
    public static var empty: TonalIndicators {
        return .init(date: Date.today, volatility: 0.0, volatilityCoeffecient: 0.0)
    }
}
