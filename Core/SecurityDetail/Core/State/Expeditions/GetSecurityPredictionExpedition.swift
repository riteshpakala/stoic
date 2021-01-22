//
//  GetSecurityPredictionExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/21/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetSecurityPredictionExpedition: GraniteExpedition {
    typealias ExpeditionEvent = SentimentSliderEvents.Value
    typealias ExpeditionState = SecurityDetailState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let neuValue = event.y
        var posValue = event.x
        var negValue = abs(event.x - 1.0)
        
        let diff = abs(1.0 - (posValue + negValue + neuValue))
        posValue -= diff/2
        negValue -= diff/2
        posValue = posValue < 0 ? 0 : posValue
        negValue = negValue < 0 ? 0 : negValue
        
        //Neu = Y
        //Float(0.5 + (0.5*(sentiment.posAverage-sentiment.negAverage))),
        
        state.tune = .init(
                        pos: posValue,
                        neg: negValue,
                        neu: neuValue,
                        compound: state.tune.compound)
        
        guard event.isActive == false else { return }
        
        guard let model = state.model else {
            return
        }
        
        state.currentPrediction = model.predict(state.tune, modelType: .close)
        state.currentPredictionPlotData = [(Date.today, state.currentPrediction.asCGFloat)]
    }
}
