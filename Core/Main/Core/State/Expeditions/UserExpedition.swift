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
        
        let authRequest = keychain.generateRequest()
        
        if let user = authRequest.data?.identifier {
            authRequest.provider.getCredentialState(forUserID: user) { authState, error in
                switch authState {
                case .authorized:
                    state.isAuthenticated = true
        //        coreDataInstance.getPortfolio(username: "test") { portfolio in
        //            if let portfolio = portfolio {
        //                connection.update(\RouterDependency.router.env.user.portfolio,
        //                                  value: portfolio,
        //                                  .here)
        //            }
        //        }
                case .notFound, .revoked, .transferred:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
}
