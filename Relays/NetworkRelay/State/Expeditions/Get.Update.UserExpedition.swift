//
//  NetworkUserExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetExpedition: GraniteExpedition {
    typealias ExpeditionEvent = NetworkEvents.User.Get
    typealias ExpeditionState = NetworkState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        publisher = state
            .service
            .login(uid: event.id)
            .replaceError(with: nil)
            .map { NetworkEvents.User.Get.Result(user: $0) }
            .eraseToAnyPublisher()
    }
}

struct UpdateUserExpedition: GraniteExpedition {
    typealias ExpeditionEvent = NetworkEvents.User.Update
    typealias ExpeditionState = NetworkState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        publisher = state
            .service
            .signup(uid: event.id, email: event.email, username: event.username)
            .replaceError(with: false)
            .map { NetworkEvents.User.Update.Result(success: $0) }
            .eraseToAnyPublisher()
    }
}

struct ApplyUserExpedition: GraniteExpedition {
    typealias ExpeditionEvent = NetworkEvents.User.Apply
    typealias ExpeditionState = NetworkState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        publisher = state
            .service
            .apply(email: event.email)
            .replaceError(with: false)
            .map { NetworkEvents.User.Apply.Result(success: $0) }
            .eraseToAnyPublisher()
    }
}
