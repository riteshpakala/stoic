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

struct StockHistoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.StockHistory
    typealias ExpeditionState = TonalCreateState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let days: Int = 7
        
        let targetComparables: [StockData] = Array(event.data.prefix(days))
        let volatilitiesTruth = targetComparables.compactMap { $0.averages?.volatility(forModelType: .close) }
        let avgVolatilitiesTruth = Double(volatilitiesTruth.reduce(0.0, +)) / Double(volatilitiesTruth.count)
        
        let chunks = event.data.chunked(into: 7)
        let scrapeTop = Array(chunks.suffix(chunks.count - 1))
        
        var candidates : [[StockData]] = [[]]
        for chunk in scrapeTop {
            let volatilities = chunk.compactMap { $0.averages?.volatility(forModelType: .close) }
            let avgVolatilities = Double(volatilities.reduce(0.0, +)) / Double(volatilities.count)
            
            let accuracy = abs(avgVolatilitiesTruth / avgVolatilities)
            
            if accuracy > 0.9 && accuracy <= 1.0 {
                candidates.append(chunk)
            }
        }
        
        print("{TEST} \(candidates.count)")
        
        for candidate in candidates {
            print("{TEST} \(candidate.first?.dateData.asString)")
        }
    }
}
