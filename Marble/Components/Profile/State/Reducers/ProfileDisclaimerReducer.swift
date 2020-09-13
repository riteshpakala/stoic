//
//  DisclaimerReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import Granite
import Foundation

struct ProfileDisclaimerReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.GetDisclaimer
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let componentToPass = component
        component.service.center.backend.get(
            route: .disclaimerUpcoming) { data in
                componentToPass.sendEvent(ProfileEvents.GetDisclaimerResponse.init(
                    disclaimers: data.compactMap {
                        Disclaimer.initialize(
                            from: $0)
                    }
                ))
        }
    }
}

struct ProfileDisclaimerResponseReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.GetDisclaimerResponse
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.disclaimers = event.disclaimers
    }
}
