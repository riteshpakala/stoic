////
////  SearchSecurityExpedition.swift
////  * stoic
////
////  Created by Ritesh Pakala on 1/7/21.
////
//
//import GraniteUI
//import SwiftUI
//import Combine
//
//struct SearchAssetStockExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.SearchResult
//    typealias ExpeditionState = AssetSearchState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
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
//        
//        state.securityData = event.result
//        state.payload = .init(object: event.result)
//    }
//}
//
//struct SearchAssetCryptoExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = CryptoEvents.SearchResult
//    typealias ExpeditionState = AssetSearchState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
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
//        
//        state.securityData = event.result
//        state.payload = .init(object: event.result)
//    }
//}
