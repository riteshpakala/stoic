//
//  TonalModelAddExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 1/30/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import Foundation
import Combine

struct TonalModelAddExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalModelsEvents.Add
    typealias ExpeditionState = TonalModelsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let router = connection.retrieve(\RouterDependency.router) else {
            return
        }
        router.request(Route.models(.init(object: state.security)))
    }
}
