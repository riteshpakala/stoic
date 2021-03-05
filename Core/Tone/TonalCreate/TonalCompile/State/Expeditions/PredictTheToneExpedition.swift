//
//  PredictTheToneExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation
import GraniteUI
import Combine

struct PredictTheToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = SentimentSliderEvents.Value
    typealias ExpeditionState = TonalCompileState
    
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
        
        guard let tone = connection.retrieve(\ToneDependency.tone) else {
            return
        }
        
        tone.compile.slider.sentiment = state.tune
        
        guard event.isActive == false else { return }

        let lastValue = tone.latestSecurity?.lastValue ?? 0.0
        
        tone.compile.model?.predict(tone, state.tune, .close, moc: coreDataInstance) { prediction in
            state.currentPrediction = prediction//tone.compile.model?.scale(prediction: prediction, lastValue) ?? state.currentPrediction
        }
    }
}
