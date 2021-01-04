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
