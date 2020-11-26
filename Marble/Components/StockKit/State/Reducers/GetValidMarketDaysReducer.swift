//
//  GetValidMarketDaysReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/8/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct GetValidMarketDaysReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.GetValidMarketDays
    typealias ReducerState = StockKitState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        //TODO: Set days here for fresh launches
        state.isPrepared = false
        
        guard component.service.center.isOnline else {
            return
        }
        
        if let component = component as? StockKitComponent {
            let currentDate = state.currentDateComponents
            component.getValidMarketDays(
                forMonth: String(currentDate.month),
                forYear: String(currentDate.year),
                target: event.target)
        }
    }
}

struct GetValidMarketDaysResponseReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.ValidMarketDaysCompleted
    typealias ReducerState = StockKitState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        //TODO:
        // Check edge cases for years, following and previous
        //
        //
        
        let stockDateDataOpen: [StockDateData] = event.result.filter { $0.isOpen }
        
        
        //MARK: Get the valid trading day today
        //It could be a holiday or it could be
        //past valid trading hours.
        var filteredForValidCurrent = stockDateDataOpen.filter {
                ($0.dateComponents.month == state.currentDateComponents.month
                && $0.dateComponents.day >= state.currentDateComponents.day) ||
                ($0.dateComponents.month > state.currentDateComponents.month) ||
                    ($0.dateComponents.year > state.currentDateComponents.year )
        }.sorted(by: { ($0.asDate ?? Date()).compare(($1.asDate ?? Date())) == .orderedAscending })
        
        if state.currentTime.hour >= state.rules.marketCloseHour && filteredForValidCurrent.first?.asString == state.currentDateAsString {
            _ = filteredForValidCurrent.removeFirst()
        }
        
        let currentYear: Int = filteredForValidCurrent.first?.dateComponents.year ?? state.currentDateComponents.year
        let currentMonth: Int = filteredForValidCurrent.first?.dateComponents.month ?? state.currentDateComponents.month
        let currentDay: Int = filteredForValidCurrent.first?.dateComponents.day ?? state.currentDateComponents.day
        
        state.nextValidTradingDay = filteredForValidCurrent.first
        //
        
        //MARK: Filter the valid trading days up to the next trading day
        var filteredForPrevious = stockDateDataOpen.filter {
               ($0.dateComponents.month == currentMonth
               && $0.dateComponents.day < currentDay) ||
               ($0.dateComponents.month < currentMonth) ||
               ($0.dateComponents.year < currentYear )
        }.sorted(by: { ($0.asDate ?? Date()).compare(($1.asDate ?? Date())) == .orderedDescending } )
        
        guard filteredForPrevious.count > 0 else {
            print("[StockKit] valid market days return - \(event.result.count)")
            return
        }
        
        var sanitizedStockData: [StockDateData] = []
        for _ in 0..<state.rules.historicalDays {
            sanitizedStockData.append(filteredForPrevious.removeFirst())
        }
        
        state.validTradingDays = (sanitizedStockData.enumerated().filter { $0.offset < state.rules.days }).map { $0.element }
        state.validHistoricalTradingDays = sanitizedStockData
        print("[StockKit] isPrepared")
        state.isPrepared = true
    }
}
