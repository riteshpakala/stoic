//
//  GetHoldingsExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/23/21.
//

import GraniteUI
import Foundation
import Combine

struct GetHoldingsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = HoldingsEvents.Get
    typealias ExpeditionState = HoldingsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        
        guard let portfolio = connection.retrieve(\EnvironmentDependency.user.portfolio) else {
            return
        }

        guard let holdings = portfolio?.holdings else { return }

        state.securitiesToSync = holdings.securities.filter { $0.isNotLatest }.map { $0 }
    }
}
