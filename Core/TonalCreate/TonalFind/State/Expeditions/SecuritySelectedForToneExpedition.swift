//
//  SecuritySelectedForToneExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct SecuritySelectedForToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetGridItemContainerEvents.SecurityTapped
    typealias ExpeditionState = TonalFindState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.payload = .init(object: Tone.init(ticker: event.security.ticker))
        connection.request(ExperienceRelayEvents.Request.init(payload: state.payload, target: .modelCreate(.find)), beam: true)
        print("{TEST} selected")
    }
}
