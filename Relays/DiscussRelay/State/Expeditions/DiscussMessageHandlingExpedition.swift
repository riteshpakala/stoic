//
//  DiscussMessageHandlingExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import Combine
import Foundation

struct DiscussSendExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Messages.Send
    typealias ExpeditionState = DiscussRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard state.channel != nil else {
            connection.request(DiscussRelayEvents.Channel.Join.init(name: "general"))
            return
        }
        GraniteLogger.info("Sent message: \(event.message)\n to #general", .relay, focus: true)
        
        state.channel?.send(event.message)
    }
}

struct DiscussReceiveExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Messages.Receive
    typealias ExpeditionState = DiscussRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info(event.payload.asString, .expedition, focus: true)
        
        switch event.payload.messageType {
        case .channel:
            state.listener?.request(DiscussRelayEvents.Messages.Result.init(payload: event.payload))
        default:
            break
        }
//        state.client?.channel.send(event.message)
    }
}
