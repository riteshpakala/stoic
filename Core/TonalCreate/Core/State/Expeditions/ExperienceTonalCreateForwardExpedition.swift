//
//  ExperienceTonalForwardExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct ExperienceTonalCreateForwardExpedition: GraniteExpedition {
    typealias ExpeditionEvent = ExperienceRelayEvents.Forward
    typealias ExpeditionState = TonalCreateState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        switch event.target {
        case .modelCreate(.find):
            state.payload = event.payload
            connection.request(TonalCreateEvents.Find.init(state.tone.ticker))
        case .modelCreate(.set):
            break
        case .modelCreate(.tune):
            break
        case .modelCreate(_):
            break
        default:
            break
        }
    }
}
