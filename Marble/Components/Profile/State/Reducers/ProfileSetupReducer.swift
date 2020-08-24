//
//  ProfileSetupReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import Firebase

struct ProfileSetupReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.ProfileSetup
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard Auth.auth().currentUser != nil else { return }
        
        guard let userData = try? component.service.center.keychain.retrieve() else {
            return
        }
        
        state.user = userData
        
        sideEffects.append(
            EventBox.init(
                event: ProfileEvents.GetDisclaimer()))
    }
}
