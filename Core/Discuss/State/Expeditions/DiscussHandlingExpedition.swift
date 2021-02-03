//
//  DiscussHandlingExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import Combine
import Foundation

struct DiscussLoadExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussEvents.Load
    typealias ExpeditionState = DiscussState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {

        connection.request(DiscussRelayEvents.Client.Listen.init(listener: connection), .contact)
    }
}

struct DiscussMessagesExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Messages.Result
    typealias ExpeditionState = DiscussState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {

        let discussMessage: DiscussMessage = .init(color: Brand.Colors.white,
                                                   data: event.payload)
        state.messages.append(discussMessage)
    }
}
