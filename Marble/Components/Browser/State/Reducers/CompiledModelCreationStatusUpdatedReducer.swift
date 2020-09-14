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
        
        state.currentCompiledCreationStatus = event.status.rawValue
        
        switch event.status {
        case .update:
            guard let stock = event.stock else { return }
            
            guard let mergedModel = state.mergedModels.first(where: { $0.stock.symbol == stock.symbol && $0.stock.exchangeName == stock.exchangeName }) else { return }
            
            
            let stocks = mergedModel.mergedStocks.descending
            guard let latestStock = stocks.first else { return }
            let otherStocks: [StockModel] = stocks.count > 1 ? Array(stocks.suffix(from: 1)) : []
            
            let data: BrowserCompiledModelCreationData = .init(baseModel: latestStock, isUpdating: true)

            data.compatibleModels = mergedModel.calculateCompatibleModels(from: otherStocks, base: latestStock)
            
            for stock in otherStocks {
                data.modelsToMerge[stock.tradingDay] = .init(stock, isUpdating: true)
            }
            
            state.compiledModelCreationData = data
            
        case .step2:
            break
        case .step3:
            sideEffects.append(.init(event: BrowserEvents.MergeModel()))
        case .none:
            if state.isCompiling {
                state.isCompiling = false
            }
            state.compiledModelCreationData = nil
        default: break
        }
    }
}
