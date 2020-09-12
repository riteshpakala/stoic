//
//  SubscriptionUpdatedBrowserReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/12/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct SubscriptionUpdatedBrowserReducer: Reducer {
    typealias ReducerEvent = ServiceCenter.Events.SubscriptionUpdated
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let subscriptionStatus = component.service.storage.get(GlobalDefaults.Subscription.self)
        state.subscription = subscriptionStatus
    }
}
