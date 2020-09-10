//
//  CompiledModelCreationStatusUpdatedReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/9/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct CompiledModelCreationStatusUpdatedReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.CompiledModelCreationStatusUpdated
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        switch event.status {
        case .step2:
            break
        case .step3:
            sideEffects.append(.init(event: BrowserEvents.MergeModel()))
        case .none:
            state.compiledModelCreationData = nil
        default: break
        }
        
        
        
        state.currentCompiledCreationStatus = event.status.rawValue
    }
}
