//
//  GetCryptoSearchExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/12/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetCryptoSearchExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.Search
    typealias ExpeditionState = CryptoState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
    }
}
