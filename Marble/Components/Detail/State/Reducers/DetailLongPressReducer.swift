//
//  DetailLongPressReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

struct DetailLongPressStartedReducer: Reducer {
    typealias ReducerEvent = DetailEvents.DetailLongPressStarted
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.lastTranslation = event.translation
        
        sideEffects.append(
            .init(
                event: DashboardEvents
                    .DetailIsInteracting
                    .init(id: component.id), bubbles: true))
    }
}

struct DetailLongPressChangedReducer: Reducer {
    typealias ReducerEvent = DetailEvents.DetailLongPressChanged
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let difference: CGPoint = .init(
            x: event.translation.x - state.lastTranslation.x,
            y: event.translation.y - state.lastTranslation.y)
        
        state.newTranslation = difference
        state.lastTranslation = event.translation
    }
}

struct DetailLongPressEndedReducer: Reducer {
    typealias ReducerEvent = DetailEvents.DetailLongPressEnded
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.newTranslation = .zero
        state.lastTranslation = .zero
    }
}
