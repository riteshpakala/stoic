//
//  DetailWillShow.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

struct UpdateSceneReducer: Reducer {
    typealias ReducerEvent = SceneEvents.ChangeScene
    typealias ReducerState = HomeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        sideEffects.append(
            .init(
                event: event,
                target: SceneComponent.self))
    }
}

struct AllDetailsDidCloseReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.AllDetailsClosed
    typealias ReducerState = HomeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        sideEffects.append(
            .init(
                event: SceneEvents.ChangeScene(scene: .home),
                target: SceneComponent.self))
    }
}
