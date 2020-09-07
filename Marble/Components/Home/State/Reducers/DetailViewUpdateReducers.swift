//
//  DetailWillShow.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

struct DetailWillShowReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.ShowDetail
    typealias ReducerState = HomeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        sideEffects.append(
            .init(
                event: SceneEvents.ChangeScene(scene: .minimized),
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
