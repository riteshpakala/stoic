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
        
        guard let portfolio = connection.retrieve(\EnvironmentDependency.user.portfolio) else {
            return
        }
        
        if let strategy = portfolio?.strategies.first {
            strategy.generate()
        }
    }
}
