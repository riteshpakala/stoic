//
//  ShowSubscribeReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct ShowSubscribeReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.ShowSubscribe
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        component.push(
            SubscribeBuilder.build(
                component.service),
            display: .modal
        )
    }
}

struct SusbcriptionUpdatedProfileReducer: Reducer {
    typealias ReducerEvent = SubscribeEvents.UpdateSubscriptionStatus
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let subscriptionStatus = component.service.storage.get(GlobalDefaults.Subscription.self)
        state.subscription = subscriptionStatus
        
        guard let subscription = component.getSubComponent(SubscribeComponent.self) else {
            return
        }
        
        component.pop(subscription, animated: true)
    }
}
