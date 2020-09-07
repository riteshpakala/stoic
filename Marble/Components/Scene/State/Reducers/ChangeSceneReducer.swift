//
//  DetailWillShowReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct ChangeSceneReducer: Reducer {
    typealias ReducerEvent = SceneEvents.ChangeScene
    typealias ReducerState = SceneState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.scene = event.scene.rawValue
    }
}
