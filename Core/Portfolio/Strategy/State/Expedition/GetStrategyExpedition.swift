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
              let portfolio = user.portfolio else {
            return
        }
        
        state.user = user.info
        
        if let strategy = portfolio.strategies.first {
            strategy.generate()
            
            let assetIDs = strategy.investments.items.filter({ !$0.closed }).map { $0.assetID }
            let quotes = strategy.quotes.filter({ assetIDs.contains($0.latestSecurity.assetID) })
            
            let securities = quotes.filter({ $0.needsUpdate }).map { $0.latestSecurity }
            
            let models = quotes.flatMap { $0.models }.filter { $0.needsUpdate }
            
            state.securitiesToSync = securities
            state.securities = strategy.quotes.map { $0.latestSecurity }
            
            GraniteLogger.info("getting strategy\nitems: \(strategy.investments.items.count)", .expedition, focus: true)
        }
    }
}
