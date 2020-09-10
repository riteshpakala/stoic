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

        let stockSymbol = state.compiledModelCreationData?.baseModel.stock.symbol
        let stockExchange = state.compiledModelCreationData?.baseModel.stock.exchangeName
        
        guard  let baseStock = state.compiledModelCreationData?.baseModel,
               let mergedModel = state.mergedModels.first(where: { $0.stock.symbol == stockSymbol && $0.stock.exchangeName == stockExchange } ) else {
                
            return
        }
        
        if let data = state.compiledModelCreationData {
            if data.modelsToMerge.keys.contains(modelDay),
               let modelData = data.modelsToMerge[modelDay],
               modelData.model.id == event.model.id {
                state.compiledModelCreationData?.modelsToMerge.removeValue(forKey: modelDay)
            
                guard let mergedStocks = state.compiledModelCreationData?.modelsToMerge.values.map({ $0.model }) else {
                    return
                }
                
                state.compiledModelCreationData?.compatibleModels = mergedModel.calculateCompatibleModels(from: [baseStock]+mergedStocks)
            } else {
                state.compiledModelCreationData?.modelsToMerge[modelDay] = .init(event.model, event.indexPath)
                
                
                guard let mergedStocks = state.compiledModelCreationData?.modelsToMerge.values.map({ $0.model }) else {
                    return
                }
                
                state.compiledModelCreationData?.compatibleModels = mergedModel.calculateCompatibleModels(from: [baseStock, event.model]+mergedStocks)
            }
        }
    }
}
