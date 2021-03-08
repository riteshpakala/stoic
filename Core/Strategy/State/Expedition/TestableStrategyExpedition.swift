//
//  TestableStrategyExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 3/8/21.
//

import GraniteUI
import SwiftUI
import Combine

struct TestableStrategyExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StrategyEvents.Get.Testable
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let strategy = state.strategy
        
        //Let's set the past changes here
        for (i, item) in strategy.investments.items.enumerated() {
            if let quote = strategy.quotes.first(where: { $0.latestSecurity.assetID == item.assetID }),
               quote.securities.count > 12 {
                let securities = Array(quote.securities.sortDesc[1...12])
                for security in securities.sortAsc {
                    strategy.investments.items[i].testable.pastChanges.append(.init(security.lastValue, security.date, isTestable: true))
                }
            }
        }
        
        //Let's find a model if there is any
        for investment in strategy.investments.items {
            if let quote = strategy.getQuoteFor(investment) {
                let model = quote.models.first(where: { $0.isStrategy }) ?? quote.models.first
                
                if let tonalModel = model {
                    //Found a model
                    investment.modelID = tonalModel.modelID
                    print("{TEST} found it")
                } else {
                    //No model found
                    print("{TEST} nothing found")
                }
            }
        }
        
        
    }
}
