//
//  UserExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import GraniteUI
import SwiftUI
import Combine

struct UserExpedition: GraniteExpedition {
    typealias ExpeditionEvent = EnvironmentEvents.User
    typealias ExpeditionState = EnvironmentState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        if let portfolio = coreDataInstance.getPortfolio(username: "test") {
            connection.update(\RouterDependency.router.env.user.portfolio,
                              value: portfolio,
                              .here)
        }
    }
}
