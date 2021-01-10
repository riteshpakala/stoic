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
            connection.update(\EnvironmentDependency.tone.find.ticker, value: event.security.ticker)
            connection.update(\EnvironmentDependency.tone.find.state, value: .found)
        case .holdings:
            print("{TEST} addddded")
            event.security.addToPortfolio(moc: coreDataInstance) { success in
                if success {
                    print("{TEST} yo")
                    connection.update(\EnvironmentDependency.portfolio.holdings.tickerToAdd,
                                      value: event.security.ticker)
                }else {
                    print(" oh no way")
                }
            }
        case .search:
            connection.update(\EnvironmentDependency.home.ticker, value: event.security.ticker)
        default:
            break
        }
    }
}
