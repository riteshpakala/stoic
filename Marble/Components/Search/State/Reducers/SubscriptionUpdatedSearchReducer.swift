//
//  SubscriptionUpdatedSearchReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/12/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct SubscriptionUpdatedSearchReducer: Reducer {
    typealias ReducerEvent = ServiceCenter.Events.SubscriptionUpdated
    typealias ReducerState = SearchState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let subscriptionStatus = component.service.storage.get(GlobalDefaults.Subscription.self)
        state.subscription = subscriptionStatus
        
        switch GlobalDefaults.Subscription.from(subscriptionStatus) {
        case .none:
            sideEffects.append(.init(event: SearchEvents.GenerateStockRotation.free))
        default:
            sideEffects.append(.init(event: SearchEvents.GenerateStockRotation.live))
            
        }
    }
}
