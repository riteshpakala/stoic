//
//  StockHistoryExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct TonalRangeChangedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = BasicSliderEvents.Value
    typealias ExpeditionState = TonalFindState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let dayDiff: Double = Double(state.maxDays - state.minDays)
        let days: Double = event.data*dayDiff
        state.days = Int(days) + state.minDays
        
        guard event.isActive == false else { return }
        
        if let tonalFind = connection.depObject(\TonalCreateDependency.tone.find.quote),
           let quote = tonalFind {
            connection.request(TonalFindEvents.Parse(quote, days: state.days))
        }
    }
}

struct ParseTonalRangeExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalFindEvents.Parse
    typealias ExpeditionState = TonalFindState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let securities = event.quote.securities
        let quote = event.quote.asQuote
        let days: Int = event.days
        state.days = days
        //
        
        //DEV: memory access error (CoreData)
        let orderedSecurities = Array(securities).sortDesc
        
        let count = orderedSecurities.count

        var volatilities: [Date:Double] = [:]
        for securityObject in orderedSecurities.prefix(count - TonalServiceModels.Indicators.trailingDays) {
            guard let security = securityObject.asSecurity else { continue }
            let indicator = TonalServiceModels.Indicators.init(security, with: quote)

            volatilities[security.date] = indicator.avgVolatility
        }

        let targetComparables = Array(orderedSecurities.prefix(days))
        let chunks = orderedSecurities.chunked(into: days)
        let scrapeTop = Array(chunks.suffix(chunks.count - 1))

        var candidates : [TonalRange] = [targetComparables.baseRange]
        for chunk in scrapeTop {
            guard chunk.count == days else { continue }

            var similarities: [Double] = []
            for i in 0..<chunk.count {
                if let targetVol = volatilities[targetComparables[i].date],
                   let chunkDayVol = volatilities[chunk[i].date] {
                    similarities.append(normalizeSim(targetVol/chunkDayVol))
                } else {
                    similarities.append(0.0)
                }
            }

            if similarities.filter( { !threshold($0) } ).isEmpty {
                let dates: [Date] = chunk.map { $0.date }

                let tSimilarities: [TonalSimilarity] = dates.enumerated().map {
                    TonalSimilarity.init(date: $0.element,
                                         similarity: similarities[$0.offset]) }

                let tIndicators: [TonalIndicators] = dates.map {
                    TonalIndicators.init(date: $0,
                                         volatility: volatilities[$0] ?? 0.0,
                                         volatilityCoeffecient: 0.0) }

                //Create an expanded chunk for a day padding
                //of an added sentiment as it is a day behind
                //during processing, and it is easier to utilize
                //the already pulled history, rather than finding
                //valid market days..
                //
                candidates.append(.init(objects: chunk,
                                        orderedSecurities
                                            .expanded(from: chunk),
                                        tSimilarities,
                                        tIndicators))
            }
        }
        
        connection.dependency(\TonalCreateDependency.tone.range, value: candidates)
    }
    
    func threshold(_ item: Double) -> Bool {
        return item <= 1.0 && item >= 0.45
    }
    
    func normalizeSim(_ item: Double) -> Double {
        guard item > 1.0 else {
            return item
        }
        
        let diff = item - 1.0
        
        return 1.0 - diff
    }
}

/* Backup
var volatilities: [Date:Double] = [:]
var volatilityCoeffecients: [Date:Double] = [:]
 
for (index, security) in orderedSecurities.enumerated() {
    // Standard deviation calculation for yearly variance
    //
    let trailing = orderedSecurities.suffix(count - index).prefix(24)
    let sum = trailing.map({ $0.lastValue }).reduce(0.0, +)
    let mean = sum/Double(trailing.count)
    
    let deviations = trailing.map({ pow($0.lastValue - mean, 2) }).reduce(0.0, +)
    let avgDeviation = deviations/Double(trailing.count - 1)
    //            print(mean)
    let standardDeviation = sqrt(avgDeviation)
    volatilities[security.date] = standardDeviation
    volatilityCoeffecients[security.date] = standardDeviation/mean
}

let targetComparables = Array(orderedSecurities.prefix(days))

let chunks = orderedSecurities.chunked(into: days)
let scrapeTop = Array(chunks.suffix(chunks.count - 1))

var candidates : [TonalRange] = []
for chunk in scrapeTop {
    guard chunk.count == days else { continue }
    
    var similarities: [Double] = []
    for i in 0..<chunk.count {
        let targetCoeffecient = volatilityCoeffecients[targetComparables[i].date] ?? 0.0
        let chunkDayCoeffecient = volatilityCoeffecients[chunk[i].date] ?? 0.0
        similarities.append(normalizeSim(targetCoeffecient/chunkDayCoeffecient))
    }
    
    if similarities.filter( { !threshold($0) } ).isEmpty {
        let dates: [Date] = chunk.map { $0.date }
        
        let tSimilarities: [TonalSimilarity] = dates.enumerated().map {
            TonalSimilarity.init(date: $0.element,
                                 similarity: similarities[$0.offset]) }
        
        let tIndicators: [TonalIndicators] = dates.map {
            TonalIndicators.init(date: $0,
                                 volatility: volatilities[$0] ?? 0.0,
                                 volatilityCoeffecient: volatilityCoeffecients[$0] ?? 0.0 ) }
        
        candidates.append(.init(objects: chunk, tSimilarities, tIndicators))
    }
}
*/


