//
//  SusbcribeProductsReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/24/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import StoreKit

struct SusbcribeProductsReducer: Reducer {
    typealias ReducerEvent = SubscribeEvents.GetProducts
    typealias ReducerState = SubscribeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.products = event.products.sorted(by: { ($0.subscriptionPeriod?.unit.rawValue ?? 0) < ($1.subscriptionPeriod?.unit.rawValue ?? 0) })
        
        state.isLoading = false
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
        
        
        SwiftyStoreKit.purchaseProduct(event.product) { result in
            switch result {
            case .success(_):
                componentToPass.sendEvent(
                    SubscribeEvents.PurchaseResult.init(
                        product: event.product,
                        success: true))
            default:
                componentToPass.sendEvent(
                    SubscribeEvents.PurchaseResult.init(
                        product: event.product,
                        success: false))
            }
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
        
        if !event.success {
            state.isLoading = false
        }
        
        guard let id = event.product?.productIdentifier else { return }
        print("{SUBSCRIBE} product-id: \(id)")
        state.purchaseResult = .init(event.success, productID: id)
    }
}
