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
        
        let stocks = event.data
        
        stocks.save(moc: coreDataInstance) { quote in
            if quote != nil {
                connection.update(\EnvironmentDependency.detail.quote, value: quote)
            } else {
                connection.update(\EnvironmentDependency.detail.stage, value: .failedFetching)
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
        
        let crypto = event.data
        
        crypto.save(moc: coreDataInstance) { quote in
            if quote != nil {
                connection.update(\EnvironmentDependency.detail.quote, value: quote)
            } else {
                connection.update(\EnvironmentDependency.detail.stage, value: .failedFetching)
            }
        }
    }
}
