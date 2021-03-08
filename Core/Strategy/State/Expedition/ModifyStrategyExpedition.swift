//
//  ModifyStrategyExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/19/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct RemoveFromStrategyExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StrategyEvents.Remove
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.wantsToRemove = nil
        
        guard let user = connection.retrieve(\EnvironmentDependency.user) else {
            return
        }
        
        guard let security = state.securities.first(where: { $0.assetID == event.assetID }) else {
            return
        }
        
        let updatedPortfolio = coreDataInstance.removeFromStrategy(username: user.info.username, security)
        
        user.portfolio = updatedPortfolio
        
        state.strategy = state.strategy.updated(moc: coreDataInstance) ?? state.strategy
        connection.update(\StrategyDependency.strategy, value: state.strategy)
        
        connection.update(\EnvironmentDependency.user, value: user)
        
        state.securities.removeAll(where: { $0.assetID == event.assetID })
        
        GraniteLogger.info("\(security.ticker) removed", .expedition, focus: true)
    }
}

struct CloseFromStrategyExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StrategyEvents.Close
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.wantsToClose = nil
        
        guard let user = connection.retrieve(\EnvironmentDependency.user) else {
            return
        }
        
        guard let security = state.securities.first(where: { $0.assetID == event.assetID }) else {
            return
        }
        
        let updatedPortfolio = coreDataInstance.closeFromStrategy(username: user.info.username, security) 
        user.portfolio = updatedPortfolio
        
        state.strategy = state.strategy.updated(moc: coreDataInstance) ?? state.strategy
        connection.update(\StrategyDependency.strategy, value: state.strategy)
        
        connection.update(\EnvironmentDependency.user, value: user)
        
        GraniteLogger.info("\(security.ticker) closed", .expedition, focus: true)
    }
}

struct PickModelForStrategyExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StrategyEvents.PickModel
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.pickingModelForSecurity = state.strategy.quotes.first(where: { $0.latestSecurity.assetID == event.assetID })?.latestSecurity
        state.stage = .choosingModel
    }
}
