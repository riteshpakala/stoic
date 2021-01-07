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
        
        print("{TEST} \(event.result.count)")
        
        connection.dependency(\EnvironmentDependency.search.securities, value: event.result)
        
        connection.dependency(\EnvironmentDependency.tone.find.state, value: .searching)
        
        state.securityData = event.result
    }
}
