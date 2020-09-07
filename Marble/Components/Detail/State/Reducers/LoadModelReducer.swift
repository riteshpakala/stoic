//
//  LoadModelReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/4/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct LoadModelReducer: Reducer {
    typealias ReducerEvent = DetailEvents.LoadModel
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        
        
    }
}
