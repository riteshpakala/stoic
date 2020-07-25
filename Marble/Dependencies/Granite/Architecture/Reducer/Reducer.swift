//
//  Reducer.swift
//  Marble
//
//  Created by Ritesh Pakala on 5/14/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

protocol AnyReducer {
    var _eventType: Event.Type? { get set }
    func execute(
        event: Event,
        state: inout State,
        sideEffects: inout [EventBox],
        component: inout AnyComponent)
}


final public class ReducerExecutable<R: Reducer>: AnyReducer {
    public var _eventType: Event.Type?
    private let reducer: R
    
    public init() {
        self.reducer = R()
        self._eventType = R.ReducerEvent.self
    }
    
    func execute(
        event: Event,
        state: inout State,
        sideEffects: inout [EventBox],
        component: inout AnyComponent) {
        
        if let mutableEvent = event as? R.ReducerEvent,
           var mutableState = state as? R.ReducerState,
           var mutableComponent = component as? Component<R.ReducerState> {
            
            reducer.reduce(
                event: mutableEvent,
                state: &mutableState,
                sideEffects: &sideEffects,
                component: &mutableComponent)
            
            state = mutableState
            component = mutableComponent
            
        } else {
            print("⚠️ Reducer was unable to execute. D[ \(R.ReducerEvent.self) \(R.ReducerState.self) ] ~ C[ \(event.self) \(state.self) ]")
            if let _ = event as? R.ReducerEvent {
                print("🛠 Event found")
            }
            
            if let _ = state as? R.ReducerState {
                print("🛠 State found")
            }
            
            if let _ = component as? Component<R.ReducerState> {
                print("🛠 Component found")
            }
        }
    }
}

public protocol Reducer {
    typealias Reducible = ReducerExecutable<Self>
    associatedtype ReducerEvent: Event
    associatedtype ReducerState: State
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>)
    
    init()
}
