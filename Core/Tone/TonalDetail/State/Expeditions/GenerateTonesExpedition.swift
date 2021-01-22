//
//  GetTonesExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/14/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GenerateTonesExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalDetailEvents.Generate
    typealias ExpeditionState = TonalDetailState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        guard let detail = connection.retrieve(\EnvironmentDependency.detail) else {
            return
        }
        
        guard detail.tonalStage == .none else {
            return
        }
        
        guard let quote = detail.quote else {
            return
        }
    
        connection.update(\EnvironmentDependency.detail.tonalStage, value: .generating)
        
        quote.getObject(moc: coreDataInstance) { object in
            if let tonalModel = object?.tonalModel?.first?.asTone {
                preparePredictions(tonalModel)
            }
        }
    }
    
    func preparePredictions(_ model: TonalModel) {
        model.predict(days: 12)
    }
}
