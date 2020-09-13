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
        
        let subscriptionStatus = component.service.storage.get(GlobalDefaults.Subscription.self)
        state.subscription = subscriptionStatus
        
        guard let browser = (component as? BrowserComponent) else { return }
        
        guard let nextValidTradingDate = (browser.stockKit?.state.nextValidTradingDay) else {
            state.nextValidTradingDay = "unknown".localized
            return
        }
        
        state.nextValidTradingDay = nextValidTradingDate.asString
        
        guard let validTradingDays = browser.stockKit?.state.validTradingDays else {
            return
        }
        
        let tradingDays: [StockDateData] = validTradingDays.sorted(by: { ($0.asDate ?? Date()).compare(($1.asDate ?? Date())) == .orderedDescending } )
        
        guard let firstDay = tradingDays.first?.asDate, let nextDate = nextValidTradingDate.asDate else {
            return
        }
        
        let components = Calendar.nyCalendar.dateComponents([.day], from: firstDay, to: nextDate)
        
        state.daysFromTrading = components.day ?? 1
    }
}
