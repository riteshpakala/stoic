//
//  ResetStrategyExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/19/21.
//

import GraniteUI
import SwiftUI
import Combine

struct ResetStrategyExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StrategyEvents.Reset
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        
        state.showResetDisclaimer = false
        
        guard let user = connection.retrieve(\EnvironmentDependency.user) else {
            return
        }
        
        
        let updatedPortfolio = coreDataInstance.resetStrategy(username: user.info.username)
        user.portfolio = updatedPortfolio
        
        connection.update(\EnvironmentDependency.user, value: user, .home)
        
        GraniteLogger.info("strategy reset", .expedition, focus: true)
    }
}
