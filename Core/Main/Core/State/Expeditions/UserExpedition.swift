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
            connection.request(NetworkEvents.User.Get.init(id: user.uid))
        }
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
                                               created: (Int(user.created) ?? 0).asDouble.date())
            
            coreDataInstance.getPortfolio(username: info.username) { portfolio in
                if let portfolio = portfolio {
                    connection.update(\RouterDependency.router.env.user.portfolio,
                                      value: portfolio, .here)
                }
                connection.update(\RouterDependency.router.env.user.info, value: info, .here)
            }
        }
    }
}
