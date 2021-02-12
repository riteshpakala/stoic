//
//  UserExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import GraniteUI
import SwiftUI
import Combine
import AuthenticationServices
import Security
import Firebase

struct UserExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MainEvents.User
    typealias ExpeditionState = MainState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        
        if  let user = FirebaseAuth.Auth.auth().currentUser {
            if connection.retrieve(\RouterDependency.authState) == AuthState.none {
                connection.request(NetworkEvents.User.Get.init(id: user.uid))
            } else if let discuss = connection.retrieve(\RouterDependency.environment.discuss),
                      let server = discuss.server {
                connection.request(DiscussRelayEvents.Client.Reconnect.init(server: server, channel: discuss.channel))
            }
        } else {
            connection.update(\RouterDependency.authState, value: .notAuthenticated, .here)
        }
    }
}

struct LogoutExpedition: GraniteExpedition {
    typealias ExpeditionEvent = MainEvents.Logout
    typealias ExpeditionState = MainState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            connection.router?.clean()
            connection.update(\RouterDependency.authState, value: .notAuthenticated, .here)
        } catch let error {
            GraniteLogger.info("Error logging out \(String(describing: error))", .expedition, focus: true)
        }
    }
}

struct DiscussSetResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = DiscussRelayEvents.Client.Set.Result
    typealias ExpeditionState = MainState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        connection.update(\RouterDependency.environment.discuss.server, value: event.server, .quiet)
        
        GraniteLogger.info("set discuss", .expedition, focus: true)
    }
}

struct LoginResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = NetworkEvents.User.Get.Result
    typealias ExpeditionState = MainState
    
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
                if let portfolio = portfolio {
                    connection.update(\RouterDependency.environment.user.portfolio,
                                      value: portfolio, .here)
                }
                
                GraniteLogger.info("set user", .expedition, focus: true)
                connection.update(\RouterDependency.authState, value: .authenticated, .here)
                connection.update(\RouterDependency.environment.user.info, value: info, .here)
                connection.request(DiscussRelayEvents.Client.Set.init(user: info))
            }
        }
    }
}
