//
//  GetStrategiesExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetStrategyExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StrategyEvents.Get
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        guard let user = connection.retrieve(\EnvironmentDependency.user),
              let strategyFromDep = connection.retrieve(\StrategyDependency.strategy),
              let portfolio = user.portfolio else {
            return
        }
        
        
        state.user = user.info
        
        //Only 1 strategy for now
        let strategyName = portfolio.strategies.first ?? ""
        
        let strategy: Strategy
        
        if strategyFromDep.name != strategyName,
           let newStrategy = coreDataInstance.getStrategy(strategyName) {
            
            strategy = newStrategy
        } else {
            strategy = strategyFromDep
        }
        
        strategy.generate()
        
        let assetIDs = strategy.investments.items.filter({ !$0.closed }).map { $0.assetID }
        let quotes = strategy.quotes.filter({ assetIDs.contains($0.latestSecurity.assetID) })
        
        let securities = quotes.filter({ $0.needsUpdate }).map { $0.latestSecurity }
        
        //models used to update as well, do it later
        let models = quotes.flatMap { $0.models }.filter { $0.needsUpdate }
        
        state.securitiesToSync = securities
        state.securities = strategy.quotes.map { $0.latestSecurity }
        
        state.strategy = strategy
        
        connection.update(\StrategyDependency.strategy, value: strategy)
        
        GraniteLogger.info("getting strategy\nitems: \(strategy.investments.items.count)", .expedition, focus: true)
    }
}
