//
//  TonalRange.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//

import Foundation
import SwiftUI

public struct TonalRange: Hashable {
    public static func == (lhs: TonalRange, rhs: TonalRange) -> Bool {
        lhs.objects == rhs.objects &&
        lhs.similarities == rhs.similarities &&
        lhs.indicators == rhs.indicators
    }
    
    let base: Bool
    let objects: [SecurityObject]
    let similarities: [TonalSimilarity]
    let indicators: [TonalIndicators]
    
    public init(
        objects: [SecurityObject],
        _ similarities: [TonalSimilarity],
        _ indicators: [TonalIndicators],
        base: Bool = false) {
        
        self.objects = objects
        self.similarities = similarities
        self.indicators = indicators
        self.base = base
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
        return base ? "Base" : "\((avgSimilarity*100).asInt)% Similar"
    }
    
    var avgSimilarityColor: Color {
        base ? Brand.Colors.yellow : (avgSimilarity > 0.6 ? Brand.Colors.green : (avgSimilarity > 0.4 ? Brand.Colors.yellow : Brand.Colors.red))
    }
    
    public static var empty: TonalRange {
        return .init(objects: [], [], [])
    }
}

extension TonalRange {
    var ticker: String {
        objects.first?.ticker ?? "error-ticker"
    }
    var symbol: String {
        "$" + (objects.first?.ticker ?? "error-ticker")
    }
}

public struct TonalSimilarity: Hashable {
    let date: Date
    let similarity: Double
    
    public static var empty: TonalSimilarity {
        return .init(date: Date.today, similarity: 0.0)
    }
}

public struct TonalIndicators: Hashable {
    let date: Date
    let volatility: Double
    let volatilityCoeffecient: Double
    
    public static var empty: TonalIndicators {
        return .init(date: Date.today, volatility: 0.0, volatilityCoeffecient: 0.0)
    }
}
