//
//  AuthExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import Foundation
import Firebase
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
        case .signup:
            connection.request(NetworkEvents.User.Apply.Code.init(code: state.code))
        case .login:
            FirebaseAuth.Auth.auth().signIn(withEmail: state.email,
                                            password: state.password) { authResult, error in
                
                if let user = authResult?.user, error == nil {
                    connection.request(NetworkEvents.User.Get.init(id: user.uid))
                } else {
                    GraniteLogger.info("Firebase Auth Login Error: \n\(String(describing: error?.localizedDescription))", .expedition, focus: true)
                }
            }
        default:
            break
        }
        
    }
}

struct AppleCodeResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = NetworkEvents.User.Apply.Code.Result
    typealias ExpeditionState = LoginState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        if let result = event.data.first {
            if result.isValid {
                FirebaseAuth.Auth.auth().createUser(withEmail: state.email,
                                       password: state.password) { authResult, error in

                    if let user = authResult?.user, error == nil {
                        connection.request(NetworkEvents.User.Update.init(id: user.uid, email: state.email, username: state.username, intent: .signup))
                    } else {
                        GraniteLogger.info("Firebase Auth Error: \n\(String(describing: error?.localizedDescription))", .expedition, focus: true)
                    }
                }
            } else {
                state.error = "// this code has been used"
            }
        } else {
            state.error = "// this code is invalid"
        }
    }
}

struct AuthResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = NetworkEvents.User.Get.Result
    typealias ExpeditionState = LoginState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        if let user = event.user {
            let info: UserInfo = .init(username: user.username,
                                               email: user.email,
                                               created: (Int(user.created) ?? 0).asDouble.date(),
                                               uid: event.id)
            
            connection.update(\RouterDependency.authState, value: .authenticated)
            connection.update(\EnvironmentDependency.user.info, value: info)
            
            connection.request(LoginEvents.AuthComplete.init(type: .login), .contact)
            
            state.success = true
        }
    }
}

struct SignupResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = NetworkEvents.User.Update.Result
    typealias ExpeditionState = LoginState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        if let user = event.user {
            let info: UserInfo = .init(username: user.username,
                                               email: user.email,
                                               created: (Int(user.created) ?? 0).asDouble.date(),
                                               uid: event.id)
            
            coreDataInstance.getPortfolio(username: info.username) { portfolio in
                let newUser: User = .init(info: info)
                if let portfolio = portfolio {
                    newUser.portfolio = portfolio
                }
                connection.update(\RouterDependency.authState, value: .authenticated, .home)
                connection.update(\EnvironmentDependency.user, value: newUser, .home)
                connection.request(DiscussRelayEvents.Client.Set.init(user: newUser))
                
                switch state.stage {
                case .signup:
                    connection.request(LoginEvents.AuthComplete.init(type: .signup), .contact)
                    state.success = true
                default:
                    break
                }
            }
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
