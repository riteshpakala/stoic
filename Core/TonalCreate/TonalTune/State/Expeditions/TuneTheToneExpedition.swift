//
//  TuneTheToneExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct TonalTuneChangedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = SentimentSliderEvents.Value
    typealias ExpeditionState = TonalTuneState
    
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
        
        if let tuner = connection.depObject(\TonalCreateDependency.tone.tuners),
           let tune = tuner[event.date]{
            
            tune.slider.sentiment = .init(
                pos: posValue,
                neg: negValue,
                neu: neuValue,
                compound: tune.slider.sentiment.compound)
            
            state.tuners[event.date] = tune
        }
        
        guard event.isActive == false else { return }
    }
}

struct TuneTheToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalCreateEvents.Tune
    typealias ExpeditionState = TonalCreateState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
//        state.stage = .tune
        print("{TEST} tuning")
        
//        state.payload = .init(object: Tone.init(range: state.tone.range, selectedRange: event.range))
//        
//        connection.request(TonalEvents.GetSentiment.init(range: event.range), beam: true)
    }
}

//struct TonalSentimentHistoryExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = TonalEvents.History
//    typealias ExpeditionState = TonalCreateState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        print(event.sentiment.stats)
//        
//        state.payload = .init(object: Tone.init(range: state.tone.range, sentiment: event.sentiment, selectedRange: state.tone.selectedRange))
//    }
//}
