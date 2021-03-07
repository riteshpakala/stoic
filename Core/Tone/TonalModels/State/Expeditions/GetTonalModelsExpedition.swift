//
//  GetTonalModelsExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetTonalModelsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalModelsEvents.Get
    typealias ExpeditionState = TonalModelsState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard state.stage == .none else { return }
        state.stage = .fetching
        
        let models = TonalModel.get(forSecurity: state.security,
                       light: true,
                       moc: coreDataInstance)
        state.tones = models
        state.stage = .none
        
        state.tonesToSync = models.filter { $0.needsUpdate }.map { $0.modelID }
    }
}
