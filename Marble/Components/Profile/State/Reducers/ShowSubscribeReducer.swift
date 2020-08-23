//
//  ShowSubscribeReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct ShowSubscribeReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.ShowSubscribe
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        component.push(
            SubscribeBuilder.build(
                component.service),
            display: .modal
        )
    }
}
