//
//  DisclaimerReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct SubscribeDisclaimerReducer: Reducer {
    typealias ReducerEvent = SubscribeEvents.GetDisclaimer
    typealias ReducerState = SubscribeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let componentToPass = component
        component.service.center.backend.get(
            route: .disclaimerUpcoming) { data in
                componentToPass.sendEvent(SubscribeEvents.GetDisclaimerResponse.init(
                    disclaimers: data.compactMap {
                        Disclaimer.initialize(
                            from: $0)
                    }
                ))
        }
    }
}

struct SubscribeDisclaimerResponseReducer: Reducer {
    typealias ReducerEvent = SubscribeEvents.GetDisclaimerResponse
    typealias ReducerState = SubscribeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.disclaimers = event.disclaimers
    }
}
