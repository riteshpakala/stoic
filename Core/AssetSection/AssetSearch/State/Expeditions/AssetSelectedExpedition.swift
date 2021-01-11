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
        case .portfolio:
            event.security.addToPortfolio(moc: coreDataInstance) { portfolio in
                if let portfolio = portfolio {
                    connection.update(\EnvironmentDependency.user.portfolio,
                                      value: portfolio)
                }
            }
        case .floor:
            let location: CGPoint
            if case let .adding(point) = state.floorStage {
                location = point
            } else {
                location = .zero
            }
            event.security.addToFloor(location: location, moc: coreDataInstance) { portfolio in
                if let portfolio = portfolio {
                    connection.update(\EnvironmentDependency.user.portfolio,
                                      value: portfolio)
                }
            }
        case .search:
            connection.update(\EnvironmentDependency.home.ticker,
                              value: event.security.ticker)
        default:
            break
        }
    }
}
