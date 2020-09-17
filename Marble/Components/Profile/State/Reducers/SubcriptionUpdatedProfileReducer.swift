//
//  ShowSubscribeReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct SubcriptionUpdatedProfileReducer: Reducer {
    typealias ReducerEvent = ServiceCenter.Events.SubscriptionUpdated
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let subscriptionStatus = component.service.storage.get(GlobalDefaults.Subscription.self)
        state.subscription = subscriptionStatus
        state.subscriptionUpdated = true
        
        if state.isRestoring == true {
            state.isRestoring = false
            
            if GlobalDefaults.Subscription.from(subscriptionStatus) == .none {
                sideEffects.append(.init(event: HomeEvents.PresentAlert("no active subscriptions found"), bubbles: true))
            }
        }
    }
}

struct SubcriptionRefreshProfileReducer: Reducer {
    typealias ReducerEvent = SubscribeEvents.Refresh
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.isRestoring = true
        state.subscriptionUpdated = false
    }
}
