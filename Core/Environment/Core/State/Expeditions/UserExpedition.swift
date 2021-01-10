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
        
        
        if let user = coreDataInstance.getUser("test"),
           let securities = user.securities,
           let conv = Array(securities) as? [Security] {
            print("{TES} oh wow. \(conv.count)")
            connection.update(\RouterDependency.router.env.portfolio.holdings.securities, value: conv, .here)
        } else {
            print("shit")
        }
    }
}
