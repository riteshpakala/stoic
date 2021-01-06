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
        
//        print("{TEST} \(posValue) \(negValue) \(neuValue) \(event.x)")
        
        state.tune = .init(
                        pos: posValue,
                        neg: negValue,
                        neu: neuValue,
                        compound: state.tune.compound)
        
        guard let tone = connection.depObject(\TonalCreateDependency.tone) else {
            return
        }
        
        tone.compile.slider.sentiment = state.tune
        
        guard event.isActive == false else { return }

        let lastValue = tone.target?.lastValue ?? 0.0
        
        let prediction = tone.compile.model?.predict(tone, state.tune, moc: coreDataInstance) ?? state.currentPrediction
        state.currentPrediction = (lastValue*prediction) + lastValue//((prediction - 1.0) * (lastValue)) + lastValue
    }
}
