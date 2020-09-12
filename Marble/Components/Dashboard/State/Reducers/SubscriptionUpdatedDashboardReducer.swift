//
//  SubscriptionUpdatedDashboardReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/12/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

struct ShowSubscribeReducer: Reducer {
    typealias ReducerEvent = SubscribeEvents.Show
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        component.push(
            SubscribeBuilder.build(
                component.service),
            display: .modalTop
        )
    }
}

struct SubscriptionUpdatedDashboardReducer: Reducer {
    typealias ReducerEvent = ServiceCenter.Events.SubscriptionUpdated
    typealias ReducerState = DashboardState
    
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
