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
        
        state.service.connect(user: .init(username: event.user.username, realName: event.user.username, nick: event.user.username, email: event.user.email, uid: event.user.uid))
        state.service.connection = connection
        
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
    }
}
