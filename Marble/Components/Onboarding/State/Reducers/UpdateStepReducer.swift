//
//  UpdateStepReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/30/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct UpdateStepReducer: Reducer {
    typealias ReducerEvent = OnboardingEvents.UpdateStep
    typealias ReducerState = OnboardingState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.currentStep = event.step
        state.index = event.index
        state.currentStep.actionable?.activate()
    }
}
