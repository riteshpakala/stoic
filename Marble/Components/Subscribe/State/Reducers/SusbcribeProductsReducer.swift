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
        
        state.products = event.products
        
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
        
        
        StoicProducts.store.buyProduct(event.product) { success, productId in
          
        }
    }
}
