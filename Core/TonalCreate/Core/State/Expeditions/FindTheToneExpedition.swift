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
        
        print(orderedSecurities.count)
        for (index, security) in orderedSecurities.enumerated() {
            
            let trailing = orderedSecurities.suffix(orderedSecurities.count - index)
            let sum = trailing.map({ $0.lastValue }).reduce(0.0, +)
            let mean = sum/Double(trailing.count)
            
            let deviations = trailing.map({ abs($0.lastValue - mean) }).reduce(0.0, +)
            let avgDeviation = deviations/Double(trailing.count)
            
            volatilities[security.date] = avgDeviation
        }
        
        for security in orderedSecurities {
            print("date: \(security.date) // volatility: \(volatilities[security.date])")
        }
//        print("\(orderedSecurities.last?.date)")
        let targetComparables = Array(orderedSecurities.prefix(days))
        
//        let volatilitiesTruth = targetComparables.compactMap { $0.averages?.volatility(forModelType: .close) }
//        let avgVolatilitiesTruth = Double(volatilitiesTruth.reduce(0.0, +)) / Double(volatilitiesTruth.count)
//
        let chunks = orderedSecurities.chunked(into: 7)
        let scrapeTop = Array(chunks.suffix(chunks.count - 1))
//
//        var candidates : [[StockData]] = [[]]
//        for chunk in scrapeTop {
////            let volatilities = chunk.compactMap { $0.averages?.volatility(forModelType: .close) }
////            let avgVolatilities = Double(volatilities.reduce(0.0, +)) / Double(volatilities.count)
////
////            let accuracy = abs(avgVolatilitiesTruth / avgVolatilities)
////
////            if accuracy > 0.9 && accuracy <= 1.2 {
////                candidates.append(chunk)
////            }
//        }
        
    }
}
