//
//  AssetSectionRefreshExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/18/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct AssetSectionNeedsRefreshExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetSectionEvents.Refresh
    typealias ExpeditionState = AssetSectionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        switch state.securityType {
        case .stock:
            connection.request(StockEvents.GetMovers(syncWithStoics: event.sync, useStoics: true), .rebound)
        case .crypto:
            connection.request(CryptoEvents.GetMovers(), .rebound)
        default:
            break
        }
    }
}

struct AssetSectionMoversStockExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.GlobalCategoryResult
    typealias ExpeditionState = AssetSectionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let movers = connection.retrieve(\EnvironmentDependency.broadcasts.movers) else {
            return
        }
        
        movers.updateStock(categories: .init(event.topVolume, event.gainers, event.losers))
    }
}

struct AssetSectionMoversCryptoExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.GlobalCategoryResult
    typealias ExpeditionState = AssetSectionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let movers = connection.retrieve(\EnvironmentDependency.broadcasts.movers) else {
            return
        }
        
        movers.updateCrypto(categories: .init(event.topVolume, event.gainers, event.losers))
    }
}
