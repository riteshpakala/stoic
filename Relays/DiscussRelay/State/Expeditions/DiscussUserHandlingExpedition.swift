//
//  DiscussUserHandlingExpedition.swift
//  stoic (iOS)
//
//  Created by Ritesh Pakala on 2/12/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct DiscussUserListExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Server.UserList
    typealias ExpeditionState = DiscussRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        GraniteLogger.info("users: \(event.users.map { $0.username })",
                           .relay,
                           focus: true)
        
        for user in event.users {
            guard user.username != state.user?.info.username else { continue }
            let channel = user.channel
            
            if let index = state.conversations.firstIndex(where: { $0.channel.name == channel }) {
                state.conversations[index].users.append(user)
            } else if let channel = state.channel {
                let newConversation: Conversation = .init(channel)
                newConversation.users = [user]
                state.conversations.append(newConversation)
            }
        }
    }
}

struct DiscussUserJoinExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Server.UserJoined
    typealias ExpeditionState = DiscussRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("users: \(event.user.username) joined",
                           .relay,
                           focus: true)
        
        if let index = state.conversations.firstIndex(where: { $0.channel.name == event.user.channel }) {
            state.conversations[index].users.removeAll(where: { $0.username == event.user.username })
            state.conversations[index].users.append(event.user)
        }
        
        //TODO: maybe make it specific to users to not
        //clog the event pool?
        //Update the user lists
        if let conversationToSend = state.conversations.first(where: { $0.channel.name == state.channel?.name }) {
            state.listener?.request(DiscussRelayEvents.Messages.Result.init(payload: conversationToSend))
        }
    }
}

struct DiscussUserLeftExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Server.UserLeft
    typealias ExpeditionState = DiscussRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("users: \(event.username) left",
                           .relay,
                           focus: true)
        
        if let index = state.conversations.firstIndex(where: { $0.channel.name == event.channel }) {
            state.conversations[index].users.removeAll(where: { $0.username == event.username })
        }
        
        //TODO: maybe make it specific to users to not
        //clog the event pool?
        //Update the user lists
        if let conversationToSend = state.conversations.first(where: { $0.channel.name == state.channel?.name }) {
            state.listener?.request(DiscussRelayEvents.Messages.Result.init(payload: conversationToSend))
        }
    }
}

struct DiscussUserQuitExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Server.UserQuit
    typealias ExpeditionState = DiscussRelayState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("users: \(event.username) left",
                           .relay,
                           focus: true)
        
        for conversation in state.conversations {
            conversation.users.removeAll(where: { $0.username == event.username })
        }
        
        //TODO: maybe make it specific to users to not
        //clog the event pool?
        //Update the user lists
        if let conversationToSend = state.conversations.first(where: { $0.channel.name == state.channel?.name }) {
            state.listener?.request(DiscussRelayEvents.Messages.Result.init(payload: conversationToSend))
        }
    }
}
