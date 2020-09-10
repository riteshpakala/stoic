//
//  BaseModelSelectedReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/9/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct BaseModelSelectedReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.BaseModelSelected
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let model = event.model else {
            return
        }
        
        if state.compiledModelCreationData?.baseModel.id == event.model?.id {
            state.compiledModelCreationData = nil
        } else {
            state.compiledModelCreationData = .init(baseModel: model, baseModelIndexPath: event.indexPath)
            
            let stockSymbol = event.model?.stock.symbol
            let stockExchange = event.model?.stock.exchangeName
            if  let stockModel = event.model,
                let mergedModel = state.mergedModels.first(where: { $0.stock.symbol == stockSymbol && $0.stock.exchangeName == stockExchange } ) {
                
                state.compiledModelCreationData?.compatibleModels =
                    mergedModel.calculateCompatibleModels(from: [stockModel])
            }
        }
        

    }
}

struct ModelToMergeReducer: Reducer {
    typealias ReducerEvent = BrowserEvents.ModelToMerge
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let modelDay: String = event.model.tradingDay
        
        if let data = state.compiledModelCreationData {
            if data.modelsToMerge.keys.contains(modelDay),
               let modelData = data.modelsToMerge[modelDay],
               modelData.model.id == event.model.id {
                state.compiledModelCreationData?.modelsToMerge.removeValue(forKey: modelDay)
            
                if let modelIndex = state.compiledModelCreationData?
                    .compatibleModels.firstIndex(
                        where: { $0.id == event.model.id }) {
                    
                    state.compiledModelCreationData?.compatibleModels.remove(at: modelIndex)
                }
            } else {
                state.compiledModelCreationData?.modelsToMerge[modelDay] = .init(event.model, event.indexPath)
                
                let stockSymbol = state.compiledModelCreationData?.baseModel.stock.symbol
                let stockExchange = state.compiledModelCreationData?.baseModel.stock.exchangeName
                if  let compatibleModels = state.compiledModelCreationData?.compatibleModels,
                    let mergedModel = state.mergedModels.first(where: { $0.stock.symbol == stockSymbol && $0.stock.exchangeName == stockExchange } ) {
                    
                    state.compiledModelCreationData?.compatibleModels =
                        mergedModel.calculateCompatibleModels(from: [event.model]+compatibleModels)
                }
            }
        }
    }
}
