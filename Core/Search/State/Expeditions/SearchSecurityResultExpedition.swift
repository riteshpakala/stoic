//
//  SearchSecurityExpeditionExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct SearchSecurityResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.SearchResult
    typealias ExpeditionState = SearchState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        switch state.context {
        case .tonalCreate:
            connection.update(\EnvironmentDependency.searchTone.securities, value: event.result)
            connection.update(\EnvironmentDependency.tone.find.state, value: .searching)
        case .holdings:
            connection.update(\EnvironmentDependency.searchAdd.securities, value: event.result)
        case .search:
            connection.update(\EnvironmentDependency.search.securities, value: event.result)
        default:
            break
        }
    }
}
