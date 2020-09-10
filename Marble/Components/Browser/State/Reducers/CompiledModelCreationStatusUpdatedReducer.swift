//
//  CompiledModelCreationStatusUpdatedReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/9/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct CompiledModelCreationStatusUpdatedReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.CompiledModelCreationStatusUpdated
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        switch event.status {
        case .step2:
//            let stockSymbol = state.compiledModelCreationData?.baseModel.stock.symbol
//            let stockExchange = state.compiledModelCreationData?.baseModel.stock.exchangeName
//            if  let stockModel = state.compiledModelCreationData?.baseModel,
//                let mergedModel = state.mergedModels.first(where: { $0.stock.symbol == stockSymbol && $0.stock.exchangeName == stockExchange } ) {
//                
//                mergedModel.calculateCompatibleModels(from: [stockModel])
//            }
            
            break
        case .none:
            state.compiledModelCreationData = nil
        default: break
        }
        
        
        
        state.currentCompiledCreationStatus = event.status.rawValue
    }
}
