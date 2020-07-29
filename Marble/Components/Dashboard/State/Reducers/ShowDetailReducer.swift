//
//  ShowDetailReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

struct ShowDetailReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.ShowDetail
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard state.activeSearchedStocks.first(
            where: { $0.symbolName == event.searchedStock.symbolName }) == nil else {
                
                print("⛑ This stock is already active")
                return
        }
        
        state.activeSearchedStocks.append(event.searchedStock)
        
        component.push(
            DetailBuilder.build(
                component.services,
                parent: component,
                event.searchedStock))
    }
}
