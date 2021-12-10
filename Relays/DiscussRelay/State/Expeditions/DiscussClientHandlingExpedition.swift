//
//  DiscussClientHandlingExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import Combine
import Foundation

struct DiscussClientHandlingExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Client.Set
    typealias ExpeditionState = DiscussRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard state.service.server == nil else {
            return
        }
        
        let info = event.user.info
        state.service.connect(user: .init(username: info.username,
                                          realName: info.username,
                                          nick: info.username,
                                          email: info.email,
                                          uid: info.uid))
        
        state.service.connection = connection
        
        state.user = event.user
        
        guard let server = state.service.server else { return }
        connection.request(DiscussRelayEvents.Client.Set.Result.init(server: server))
        
        GraniteLogger.info("client was set, sending server back", .relay, focus: false)
    }
}

struct DiscussClientReconnectExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Client.Reconnect
    typealias ExpeditionState = DiscussRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.service.server = event.server
        connection.request(DiscussRelayEvents.Channel.Join.init(name: event.channel))
        
        GraniteLogger.info("reconnecting to \(event.channel)", .relay, focus: false)
    }
}

struct DiscussClientRegisteredExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Client.Registered
    typealias ExpeditionState = DiscussRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        connection.request(DiscussRelayEvents.Channel.Join.init(name: "general"))
        
        GraniteLogger.info("client registered", .relay, focus: false)
    }
}

struct DiscussClientListenerExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Client.Listen
    typealias ExpeditionState = DiscussRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.listener = event.listener
        
        GraniteLogger.info("listener added", .relay, focus: false)
        
        if let conversationToSend = state.conversations.first(where: { $0.channel.name == state.channel?.name }) {
            state.listener?.request(DiscussRelayEvents.Messages.Result.init(payload: conversationToSend))
        }
    }
}

struct DiscussChannelJoinExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Channel.Join
    typealias ExpeditionState = DiscussRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.channel = state.service.server?.join(event.name)
        
        state.service.server?.send("NAMES #\(event.name)")
        
        GraniteLogger.info("Join channel: \(event.name)", .relay, focus: false)
    }
}
