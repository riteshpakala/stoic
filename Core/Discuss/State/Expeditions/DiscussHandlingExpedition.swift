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
        
        GraniteLogger.info("loaded", .event, focus: false)
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
        
        state.currentChannel = event.payload.channel.name
        state.messages = event.payload.messages
        state.users = event.payload.users.map { User.guest(with: $0.username) }
    }
}

struct DiscussSendMessageExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussEvents.Send
    typealias ExpeditionState = DiscussState

    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {

        guard state.currentMessage.isNotEmpty,
              let user = connection.retrieve(\EnvironmentDependency.user) else { return }
        
        
        let message = DiscussMessage
            .init(color: Brand.Colors.yellow,
                  data: .init(username: user.info.username,
                              message: state.currentMessage,
                              channel: state.currentChannel,
                              date: .today,
                              messageType: .channel))
        
        
        connection.request(DiscussRelayEvents.Messages.Send.init(message: message), .contact)
        
        state.currentMessage = ""
    }
}
