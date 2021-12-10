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
        
        let conversation: Conversation?
        if let index = state.conversations.firstIndex(where: { $0.channel.name == state.channel?.name }) {
            state.conversations[index].messages.append(event.message)
            conversation = state.conversations[index]
        } else if let channel = state.channel {
            let newConversation: Conversation = .init(channel)
            newConversation.messages.append(event.message)
            state.conversations.append(newConversation)
            conversation = newConversation
        } else {
            conversation = nil
        }
        
        state.channel?.send(event.message.data.message)
        
        if let conversationToSend = conversation {
            state.listener?.request(DiscussRelayEvents.Messages.Result.init(payload: conversationToSend))
        }
        
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
            
            let conversation: Conversation?
            if let index = state.conversations.firstIndex(where: { $0.channel.name == event.payload.channel }) {
                state.conversations[index].messages.append(.init(color: .white, data: event.payload))
                conversation = state.conversations[index]
            } else if let channel = state.channel {
                let newConversation: Conversation = .init(channel)
                newConversation.messages.append(.init(color: .white, data: event.payload))
                state.conversations.append(newConversation)
                conversation = newConversation
            } else {
                conversation = nil
            }
            
            if let conversationToSend = conversation {
                state.listener?.request(DiscussRelayEvents.Messages.Result.init(payload: conversationToSend))
            }
            
            GraniteLogger.info("Received message: \(event.payload.message)\n conversations: \(state.conversations.count) // id:\(ObjectIdentifier.init(state.service))\nmessages:\(state.conversations.first?.messages.count ?? 0) to #\(event.payload.channel)", .relay, focus: true)
        case .server:
            GraniteLogger.info("Received SERVER message: \(event.payload.message) from #\(event.payload.channel)", .relay, focus: false)
        }
    }
}
