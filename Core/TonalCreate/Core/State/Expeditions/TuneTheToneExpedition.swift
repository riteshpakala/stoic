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
        
        connection.request(TonalEvents.GetSentiment.init(range: event.range))
    }
}

