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

struct SecurityDetailResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.History
    typealias ExpeditionState = SecurityDetailState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let stocks = event.data.first?.asStocks(interval: event.interval) else {
            connection.update(\EnvironmentDependency.detail.isFetching, value: false)
            return
        }
        
        //TODO: Infinite loop
        //
        stocks.save(moc: coreDataInstance) { quote in
            if let object = quote {
                state.quote = object
                connection.update(\EnvironmentDependency.detail.isFetching, value: false)
            }
            
            connection.update(\EnvironmentDependency.detail.isFetching, value: false)
        }
    }
}
