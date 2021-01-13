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
        
        TonalModel.get(forSecurity: state.security,
                       moc: coreDataInstance) { models in
            state.tones = models
            state.stage = .none
        }
       
//        if let model = models.first {
//            print("{TEST} prediction: \(model.predict())")
//        }
    }
}
