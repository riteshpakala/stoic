//
//  MoversExpedition.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/9/21.
//

import GraniteUI
import SwiftUI
import Combine

struct MoversStockExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.GlobalCategoryResult
    typealias ExpeditionState = EnvironmentState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let movers = connection.retrieve(\RouterDependency.environment.broadcasts.movers) else {
            return
        }
        
        movers.updateStock(categories: .init(event.topVolume, event.gainers, event.losers))
        
        connection.hear()
    }
}

struct MoversCryptoExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.GlobalCategoryResult
    typealias ExpeditionState = EnvironmentState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {

        guard let movers = connection.retrieve(\RouterDependency.environment.broadcasts.movers) else {
            return
        }
        
        movers.updateCrypto(categories: .init(event.topVolume, event.gainers, event.losers))
        
        connection.hear()
    }
}
