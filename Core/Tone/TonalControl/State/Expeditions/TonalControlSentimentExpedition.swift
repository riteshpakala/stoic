//
//  TonalControlProcessExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/25/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct TonalControlSentimentExpedition: GraniteExpedition {
    typealias ExpeditionEvent = SentimentSliderEvents.Value
    typealias ExpeditionState = TonalControlState
    
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
        
        let newSentiment: SentimentOutput = .init(
            pos: posValue,
            neg: negValue,
            neu: neuValue,
            compound: 0.0)
        
        state.tuner.sentiment = newSentiment
        
        guard event.isActive == false else { return }
        
        guard var model = state.model else {
            return
        }
        print("{TEST} \(state.currentPrediction) \(state.model?.last12SecuritiesDailies.isEmpty)")
        
        state.currentPrediction = model.predictAll(state.tuner.sentiment)
        
//        connection.request(TonalControlEvents.Prediction.init(data: state.currentPrediction), .contact)
//        state.currentPredictionPlotData = [(Date.today, state.currentPrediction.asCGFloat)]
    }
}
