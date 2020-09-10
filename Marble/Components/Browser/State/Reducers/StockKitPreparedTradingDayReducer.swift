//
//  StockKitPreparedTradingDay.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/9/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

struct StockKitPreparedTradingDayReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.StockKitIsPrepared
    typealias ReducerState = BrowserState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.nextValidTradingDay = ((component as? BrowserComponent)?.stockKit?.state.nextValidTradingDay?.asString ?? "unknown".localized)
    }
}
