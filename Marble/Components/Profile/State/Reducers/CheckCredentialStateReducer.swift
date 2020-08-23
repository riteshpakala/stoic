//
//  CheckCredentialStateReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import AuthenticationServices
import Security

struct CheckCredentialStateReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.CheckCredential
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
            
        
    }
}
