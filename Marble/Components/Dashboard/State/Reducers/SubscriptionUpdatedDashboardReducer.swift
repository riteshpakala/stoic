//
//  SubscriptionUpdatedDashboardReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/12/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import Firebase
import UIKit

struct ShowSubscribeReducer: Reducer {
    typealias ReducerEvent = SubscribeEvents.Show
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard Auth.auth().currentUser != nil else {
            component.push(
                ProfileBuilder.build(component.service),
                display: .modal)
            
            return
        }
        
        component.push(
            SubscribeBuilder.build(
                component.service),
            display: .modalTop)
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
        
        //Update settings options if a detail view was spawned
        //with changed preferences
        let settingsItem = GlobalDefaults.instance.writeableDefaults
        for item in settingsItem {
            if let index = state.settingsItems?.firstIndex(
                where: { $0.label == item.key }) {
                state.settingsItems?[index].isSubscribed = GlobalDefaults.Subscription.from(subscriptionStatus).isActive
            }
        }
        
        state.settingsDidUpdate = state.settingsDidUpdate % 12
        //
        
        guard let subscription = component.getSubComponent(SubscribeComponent.self) else {
            return
        }
        
        component.pop(subscription, animated: true)
    }
}
