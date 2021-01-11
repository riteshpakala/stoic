//
//  SearchSecurityExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//

import GraniteUI
import SwiftUI
import Combine

struct SearchAssetExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.SearchResult
    typealias ExpeditionState = AssetSearchState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        print("{TEST} \(event.result.count) \(state.context)")
        
        switch state.context {
        case .tonalCreate:
            connection.update(\EnvironmentDependency.searchTone.securities, value: event.result)
            connection.update(\EnvironmentDependency.tone.find.state, value: .searching)
        case .portfolio:
            connection.update(\EnvironmentDependency.holdingsPortfolio.assetAddState.searchState.securities, value: event.result)
        case .floor:
            connection.update(\EnvironmentDependency.holdingsFloor.assetAddState.searchState.securities, value: event.result)
        case .search:
            connection.update(\EnvironmentDependency.search.securities, value: event.result)
        default:
            break
        }
        
        state.securityData = event.result
        state.payload = .init(object: event.result)
    }
}
