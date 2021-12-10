//
//  TonalControlGenerate.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/22/21.
//

import Foundation
import GraniteUI
import Combine
import SwiftUI

struct TonalControlGenerateExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalControlEvents.Generate
    typealias ExpeditionState = TonalControlState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let model = state.model else { return }
//        model.david.sentiments
        let avg = model.david.sentimentAvg
        connection.request(TonalControlEvents.Predict.init(sentiment: avg))
    }
}

struct TonalControlPredictExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalControlEvents.Predict
    typealias ExpeditionState = TonalControlState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard var model = state.model else {
            return
        }
        
        state.tuner.sentiment = event.sentiment
        state.currentPrediction = model.predictAll(event.sentiment)
        GraniteLogger.info("Sentiment output being tested:\n\(event.sentiment.asString)", .expedition, focus: true)
    }
}
