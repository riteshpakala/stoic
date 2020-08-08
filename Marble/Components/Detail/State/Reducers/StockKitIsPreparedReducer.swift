//
//  StockKitIsPreparedReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/8/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct StockKitIsPreparedReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.StockKitIsPrepared
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let symbolName = state.searchedStock.symbolName else { return }
        sideEffects.append(
            .init(
                event: DetailEvents.GetCSV(
                    ticker: symbolName)))
    }
}
