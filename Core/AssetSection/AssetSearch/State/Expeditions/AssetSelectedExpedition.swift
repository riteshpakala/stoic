//
//  AssetSelectedExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//

import GraniteUI
import SwiftUI
import Combine

struct AssetSelectedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetGridItemContainerEvents.SecurityTapped
    typealias ExpeditionState = AssetSearchState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {

        
        switch state.context {
        case .tonalCreate:
            connection.dependency(\EnvironmentDependency.tone.find.ticker, value: event.security.ticker)
            connection.dependency(\EnvironmentDependency.tone.find.state, value: .found)
        case .holdings:
            connection.dependency(\EnvironmentDependency.portfolio.holdings.tickerToAdd, value: event.security.ticker)
        case .search:
            connection.dependency(\EnvironmentDependency.home.ticker, value: event.security.ticker)
        default:
            break
        }
        
        
    }
}
