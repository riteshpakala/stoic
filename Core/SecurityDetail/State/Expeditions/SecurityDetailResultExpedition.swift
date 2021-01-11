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
            return
        }
        
        stocks.save(moc: coreDataInstance) { quote in
            if let object = quote?.asQuote {
                state.quote = object
                
                connection.update(\EnvironmentDependency.detail.isFetching, value: false)
            }
        }
    }
}
