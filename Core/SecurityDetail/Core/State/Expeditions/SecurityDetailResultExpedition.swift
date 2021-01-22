//
//  SecurityDetailResultExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct StockDetailResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.History
    typealias ExpeditionState = SecurityDetailState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let portfolio = connection.retrieve(\EnvironmentDependency.user.portfolio) else {
            GraniteLogger.error("no portfolio found\nself:\(self)", .expedition)
            return
        }
        
        GraniteLogger.info("relaying stock quotes\nself:\(self)", .expedition)
        
        let stocks = event.data
        
        stocks.save(moc: coreDataInstance) { quote in
            if state.isExpanded {
                if quote != nil {
                    connection.update(\EnvironmentDependency.detail.quote, value: quote)
                } else {
                    connection.update(\EnvironmentDependency.detail.stage, value: .failedFetching)
                }
            } else {
                if quote != nil {
                    portfolio?.updateDetailQuote(state.security, quote: quote)
                } else {
                    portfolio?.updateDetailStage(state.security, stage: .failedFetching)
                }
                connection.update(\EnvironmentDependency.user.portfolio, value: portfolio)
            }
        }
    }
}

struct CryptoDetailResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.History
    typealias ExpeditionState = SecurityDetailState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let portfolio = connection.retrieve(\EnvironmentDependency.user.portfolio) else {
            GraniteLogger.error("no portfolio found\nself:\(self)", .expedition)
            return
        }
        
        let crypto = event.data
        
        crypto.save(moc: coreDataInstance) { quote in
            if state.isExpanded {
                if quote != nil {
                    connection.update(\EnvironmentDependency.detail.quote, value: quote)
                } else {
                    connection.update(\EnvironmentDependency.detail.stage, value: .failedFetching)
                }
            } else {
                if quote != nil {
                    portfolio?.updateDetailQuote(state.security, quote: quote)
                } else {
                    portfolio?.updateDetailStage(state.security, stage: .failedFetching)
                }
                connection.update(\EnvironmentDependency.user.portfolio, value: portfolio)
            }
        }
    }
}
