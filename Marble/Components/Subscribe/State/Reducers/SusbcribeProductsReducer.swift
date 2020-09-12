//
//  SusbcribeProductsReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/24/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

struct SusbcribeProductsReducer: Reducer {
    typealias ReducerEvent = SubscribeEvents.GetProducts
    typealias ReducerState = SubscribeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.products = event.products.sorted(by: { ($0.subscriptionPeriod?.unit.rawValue ?? 0) < ($1.subscriptionPeriod?.unit.rawValue ?? 0) })
        
        print("{TEST} products \(event.products.count)")
    }
}

struct SusbcribeSelectedProductReducer: Reducer {
    typealias ReducerEvent = SubscribeEvents.SelectedProduct
    typealias ReducerState = SubscribeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.isLoading = true
        let componentToPass = component
        StoicProducts.store.buyProduct(event.product) { success, productId in
            componentToPass.sendEvent(
                SubscribeEvents.PurchaseResult.init(
                    product: productId,
                    success: success))
        }
    }
}

struct SusbcribePurchaseResultReducer: Reducer {
    
    typealias ReducerEvent = SubscribeEvents.PurchaseResult
    typealias ReducerState = SubscribeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.purchaseResult = .init(event.success, productID: event.product)
        
        print("{LSV} purchase result heard \(event.success)")
    }
}
