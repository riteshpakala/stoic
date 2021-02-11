//
//  BroadcastsExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/11/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import Foundation
import Combine

struct BroadcastsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = EnvironmentEvents.Broadcasts
    typealias ExpeditionState = EnvironmentState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        connection.request(StockEvents.GetMovers(), .rebound)
        connection.request(CryptoEvents.GetMovers(), .rebound)
    }
}
