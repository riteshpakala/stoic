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
        
        if  let user = FirebaseAuth.Auth.auth().currentUser, connection.retrieve(\RouterDependency.env.auth)?.isReady == false {
            connection.request(NetworkEvents.User.Get.init(id: user.uid))
        }
//        let authRequest = keychain.generateRequest()
//
//        if let user = authRequest.data?.identifier {
//            authRequest.provider.getCredentialState(forUserID: user) { authState, error in
//                switch authState {
//                case .authorized:
//                    break
//        //        coreDataInstance.getPortfolio(username: "test") { portfolio in
//        //            if let portfolio = portfolio {
//        //                connection.update(\RouterDependency.router.env.user.portfolio,
//        //                                  value: portfolio,
//        //                                  .here)
//        //            }
//        //        }
//                case .notFound, .revoked, .transferred:
//                    break
//                @unknown default:
//                    break
//                }
//            }
//        }
    }
}

struct LoginMainResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = NetworkEvents.User.Get.Result
    typealias ExpeditionState = MainState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        if let user = event.user {
            let auth: Auth = .init(user: .init(username: user.username,
                                               email: user.email,
                                               created: (Int(user.created) ?? 0).asDouble.date()))
            
            coreDataInstance.getPortfolio(username: auth.user.username) { portfolio in
                if let portfolio = portfolio {
                    connection.update(\RouterDependency.router.env.user.portfolio,
                                      value: portfolio)
                }
                
                connection.update(\RouterDependency.env.auth, value: auth, .home)
            }
        }
    }
}
