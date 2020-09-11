//
//  UpdateSubscriptionStatus.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/11/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import Granite

struct UpdateSubscriptionStatusReducer: Reducer {
    typealias ReducerEvent = SubscribeEvents.UpdateSubscriptionStatus
    typealias ReducerState = SubscribeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {

        let componentToPass = component
        component.service.center.checkSubscription { [weak componentToPass] subscription in
            if let value = subscription.values.first(where:  { $0 != .none } ) {
                componentToPass?.service.storage.update(value)
            }
        }
        print("{SUBSCRIBE} status sub updated heard")
    }
}
