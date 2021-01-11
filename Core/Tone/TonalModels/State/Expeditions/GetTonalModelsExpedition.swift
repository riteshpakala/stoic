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
        
        guard let models = TonalModel.get(moc: coreDataInstance) else {
            print("{TEST} model failed 5")
            return
        }
        print("{TEST} fetching -- tonalmodels \(models.count)")
        
        state.tones = models
        if let model = models.first {
            print("{TEST} prediction: \(model.predict())")
        }
    }
}
