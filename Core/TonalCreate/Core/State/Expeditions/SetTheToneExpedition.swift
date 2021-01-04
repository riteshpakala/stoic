//
//  FindTheToneExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/25/20.
//
import Foundation
import GraniteUI
import Combine

struct SetTheToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalCreateEvents.Set
    typealias ExpeditionState = TonalCreateState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
       
        
    }
}


//MARK: -- BACKUP

/*
//
//  FindTheToneExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/25/20.
//
import Foundation
import GraniteUI
import Combine

struct FindTheToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalCreateEvents.Find
    typealias ExpeditionState = TonalCreateState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let securities = event.quote.securities
        let days: Int = 7
        //
        
        let orderedSecurities = Array(securities.sorted(by: { $0.date.compare($1.date) == .orderedDescending })).filter( { $0.date.compare("2016-01-29".asDate() ?? Date.today) == .orderedDescending } )
        
        let count = orderedSecurities.count
        
        print("{TEST} found \(count)")
        
        var volatilities: [Date:Double] = [:]
        var volatilityCoeffecients: [Date:Double] = [:]
        
        for (index, security) in orderedSecurities.enumerated() {
//            let nextStockIndex = min(index + 1, orderedSecurities.count - 1)
//            let nextStock = orderedSecurities[nextStockIndex]
//            let volatility = security.lastValue - nextStock.lastValue
//            let coeffecient = volatility/nextStock.lastValue
//
//            volatilities[security.date] = volatility
//            volatilityCoeffecients[security.date] = coeffecient
//            let components = security.date.dateComponents()
//            if components.year == 2016, components.month == 1 {
//                print(sum)
//                print(deviations)
//                print(trailing)
//            }
            
            // Standard deviation calculation for yearly variance
            //
            let trailing = orderedSecurities.suffix(orderedSecurities.count - index).prefix(24)
            let sum = trailing.map({ $0.lastValue }).reduce(0.0, +)
            let mean = sum/Double(trailing.count)
            
            let deviations = trailing.map({ pow($0.lastValue - mean, 2) }).reduce(0.0, +)
            let avgDeviation = deviations/Double(trailing.count - 1)
            //            print(mean)
            let standardDeviation = sqrt(avgDeviation)
            volatilities[security.date] = standardDeviation
            volatilityCoeffecients[security.date] = standardDeviation/mean
        }
        
//        for security in orderedSecurities {
//            print("date: \(security.date) // volatilities: \(volatilityCoeffecients[security.date])")
//        }

//
//
//        print("\(orderedSecurities.last?.date)")
        let targetComparables = Array(orderedSecurities.prefix(days))
        
        let chunks = orderedSecurities.chunked(into: days)
        let scrapeTop = Array(chunks.suffix(chunks.count - 1))

        var candidates : [TonalRange] = []
        var coeffecients: [[Double]] = []
        var coeffecientAverages: [Double] = []
        for chunk in scrapeTop {
            guard chunk.count == days else { continue }
            
            
            var similarities: [Double] = []
            for i in 0..<chunk.count {
                let targetCoeffecient = volatilityCoeffecients[targetComparables[i].date] ?? 0.0
                let chunkDayCoeffecient = volatilityCoeffecients[chunk[i].date] ?? 0.0
                similarities.append(targetCoeffecient/chunkDayCoeffecient)
            }
            
//            let sumOfSimilarities = similarities.map({ abs($0) }).reduce(0.0, +)
//            let avgOfSimilarities = sumOfSimilarities/Double(similarities.count)
            
            if similarities.filter( { !($0 <= 1.2 && $0 >= 0.75) } ).isEmpty {
                let dates: [Date] = chunk.map { $0.date }
                
                let tSimilarities: [TonalSimilarity] = dates.enumerated().map {
                    TonalSimilarity.init(date: $0.element,
                                         similarity: similarities[$0.offset]) }
                
                let tIndicators: [TonalIndicators] = dates.map {
                    TonalIndicators.init(date: $0,
                                         volatility: volatilities[$0],
                                         volatilityCoeffecient: volatilityCoeffecients[$0] ) }
//                candidates.append(chunk)
//                coeffecients.append(similarities)
//                coeffecientAverages.append(avgOfSimilarities)
            }
        }
        
//        state.payload = .init(object: state.securityData)
        
        for (index, candidate) in candidates.enumerated() {
            print("%%%%%%%%%%%%%%%%%%")
            print("\(candidates.count) // \(coeffecients.count) // \(coeffecientAverages.count)")
            print("Dates: \(candidate.first?.date)")
            print("Volatilities: \(coeffecients[index])")
            print("Average: \(coeffecientAverages[index])")
        }
        
    }
}

*/
