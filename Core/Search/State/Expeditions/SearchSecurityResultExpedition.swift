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
        
        print("{TEST} hey hey hey \(state.context)")
        
        switch state.context {
        case .tonalCreate:
            connection.dependency(\EnvironmentDependency.searchTone.securities, value: event.result)
            connection.dependency(\EnvironmentDependency.tone.find.state, value: .searching)
        case .holdings:
            connection.dependency(\EnvironmentDependency.searchAdd.securities, value: event.result)
        case .search:
            connection.dependency(\EnvironmentDependency.search.securities, value: event.result)
        default:
            break
        }
    }
}
