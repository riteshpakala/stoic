//
//  CloseDetailReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/2/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

struct CloseDetailReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.CloseDetail
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        if let index = state.activeSearchedStocks.firstIndex(
            where: { $0.symbolName == event.searchedStock.symbolName }) {
            
            state.activeSearchedStocks.remove(at: index)
        }
        
        guard let detail = component.getSubComponent(id: event.id) as? DetailComponent else {
            return
        }

        component.deattach(detail)
    }
}
