//
//  GenerateStockRotationReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct GenerateStockRotationReducer: Reducer {
    typealias ReducerEvent = SearchEvents.GenerateStockRotation
    typealias ReducerState = SearchState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {

        state.subscription = component.service.storage.get(GlobalDefaults.Subscription.self)
        
        switch event {
        case .free:

            let componentToPass = component
            component.service.center.backend.get(
              route: .globalStocksFreeRotation) { data in
                  
              componentToPass.sendEvent(
                      SearchEvents.GenerateStockRotationResponse(
                          stocks: data.compactMap {
                              SearchStock.initialize(from: $0)
                              
                      }
                  )
              )
            }
        case .live:
            guard GlobalDefaults.Subscription.from(state.subscription).isActive else { return }
            let componentToPass = component
            component.service.center.backend.get(
                route: .general,
                server: .search,
                query: .limitFirst(12)) { data in
              componentToPass.sendEvent(
                      SearchEvents.GenerateStockRotationResponse(
                          stocks: data.compactMap {
                              SearchStock.initialize(from: $0)

                      }
                  )
              )
            }
            break
        }
        
        state.isLoadingRotation = true
    }
}

struct GenerateStockRotationResponseReducer: Reducer {
    typealias ReducerEvent = SearchEvents.GenerateStockRotationResponse
    typealias ReducerState = SearchState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.stockRotation = event.stocks
        state.isLoadingRotation = false
    }
}
