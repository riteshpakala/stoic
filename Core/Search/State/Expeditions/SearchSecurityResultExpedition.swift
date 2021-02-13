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

struct SearchStockResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.SearchResult
    typealias ExpeditionState = SearchState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
//        switch state.context {
//        case .tonalCreate:
//            connection.update(\EnvironmentDependency.searchTone.securityGroup.stocks, value: event.result)
//            connection.update(\EnvironmentDependency.tone.find.state, value: .searching)
//        case .portfolio:
//            connection.update(\EnvironmentDependency.holdingsPortfolio.assetAddState.searchState.securityGroup.stocks, value: event.result)
//        case .floor:
//            connection.update(\EnvironmentDependency.holdingsFloor.assetAddState.searchState.securityGroup.stocks, value: event.result)
//        case .search:
//            connection.update(\EnvironmentDependency.search.securityGroup.stocks, value: event.result)
//        default:
//            break
//        }
    }
}

struct SearchCryptoResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.SearchResult
    typealias ExpeditionState = SearchState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        connection.request(SearchEvents.Result(securities: event.result), .contact)
        
//        switch state.context {
//        case .tonalCreate:
//            connection.update(\EnvironmentDependency.searchTone.securityGroup.crypto, value: event.result)
//            connection.update(\EnvironmentDependency.tone.find.state, value: .searching)
//        case .portfolio:
//            connection.update(\EnvironmentDependency.holdingsPortfolio.assetAddState.searchState.securityGroup.crypto, value: event.result)
//        case .floor:
//            connection.update(\EnvironmentDependency.holdingsFloor.assetAddState.searchState.securityGroup.crypto, value: event.result)
//        case .search:
//            connection.update(\EnvironmentDependency.search.securityGroup.crypto, value: event.result)
//        default:
//            break
//        }
    }
}
