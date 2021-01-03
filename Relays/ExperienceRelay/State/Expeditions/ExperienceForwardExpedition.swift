//
//  ExperienceForwardExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct ExperienceForwardExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ExperienceRelayEvents.Request
    typealias ExpeditionState = ExperienceRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        print("{TEST} yooooo")
        connection.request(ExperienceRelayEvents.Forward(payload: event.payload, target: event.target), beam: true)
    }
}
