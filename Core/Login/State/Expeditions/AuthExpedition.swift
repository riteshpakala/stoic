//
//  AuthExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import Foundation
import Combine

struct AuthExpedition: GraniteExpedition {
    typealias ExpeditionEvent = LoginEvents.Auth
    typealias ExpeditionState = LoginState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.success = false
        state.error = nil
        
        let auth: AuthValidator.AuthValidatorType
        
        switch state.stage {
        case .apply:
            guard state.isReadyForApplying else {
                state.error = "// please fill out each field"
                return
            }
            auth = .email
        case .login:
            guard state.isReadyForLogin else {
                state.error = "// please fill out each field"
                return
            }
            auth = .login
        case .signup:
            guard state.isReadyForSignup else {
                state.error = "// please fill out each field"
                return
            }
            auth = .all
        default:
            auth = .none
        }
        
        guard AuthValidator.email(state.email) else {
            state.error = AuthValidator.AuthValidatorType.email.error
            return
        }
        
        guard auth == .login || auth == .all else {
            if auth == .email {
                authenticate(state, connection)
            }
            return
        }
        
        guard AuthValidator.password(state.password) else {
            state.error = AuthValidator.AuthValidatorType.password.error
            return
        }
        
        guard auth == .all else {
            authenticate(state, connection)
            return
        }
        
        guard AuthValidator.username(state.username) else {
            state.error = AuthValidator.AuthValidatorType.username.error
            return
        }
        
        authenticate(state, connection)
    }
    
    func authenticate(_ state: ExpeditionState, _ connection: GraniteConnection) {
        
        switch state.stage {
        case .apply:
            connection.request(NetworkEvents.User.Apply.init(email: state.email))
        default:
            break
        }
        
    }
}

struct ApplyResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = NetworkEvents.User.Apply.Result
    typealias ExpeditionState = LoginState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        
        state.success = true
    }
}
