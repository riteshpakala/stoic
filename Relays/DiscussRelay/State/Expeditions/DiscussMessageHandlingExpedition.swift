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
        
        if let index = state.conversations.firstIndex(where: { $0.channel.name == state.channel?.name }) {
            state.conversations[index].messages.append(event.message)
        } else if let channel = state.channel {
            let conversation: Conversation = .init(channel)
            conversation.messages.append(event.message)
            state.conversations.append(conversation)
        }
        
        state.channel?.send(event.message.data.message)
        
        GraniteLogger.info("Sent message: \(event.message.data.message)\n conversations: \(state.conversations.count) // id:\(ObjectIdentifier.init(state.service))\nmessages:\(state.conversations.first?.messages.count ?? 0) to #\(event.message.data.channel)", .relay, focus: true)
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
        
        GraniteLogger.info(event.payload.asString, .expedition)
        
        switch event.payload.messageType {
        case .channel:
//            state.listener?.request(DiscussRelayEvents.Messages.Result.init(payload: event.payload))
            
            if let index = state.conversations.firstIndex(where: { $0.channel.name == event.payload.channel }) {
                state.conversations[index].messages.append(.init(color: .white, data: event.payload))
            } else if let channel = state.channel {
                let conversation: Conversation = .init(channel)
                conversation.messages.append(.init(color: .white, data: event.payload))
                state.conversations.append(conversation)
            }
            
            GraniteLogger.info("Received message: \(event.payload.message)\n conversations: \(state.conversations.count) // id:\(ObjectIdentifier.init(state.service))\nmessages:\(state.conversations.first?.messages.count ?? 0) to #\(event.payload.channel)", .relay, focus: true)
        default:
            break
        }
    }
}
