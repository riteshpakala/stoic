//
//  GetSearchResultsReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

struct GetSearchResultsReducer: Reducer {
    typealias ReducerEvent = SearchEvents.GetSearchResults
    typealias ReducerState = SearchState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.searchTimer?.invalidate()
        state.searchTimer = nil
        guard let stockKit = component.getSubComponent(
            StockKitComponent.self) as? StockKitComponent else {
            return
        }
        state.searchTimer = Timer.scheduledTimer(
            withTimeInterval: state.searchDelay,
            repeats: false) { timer in
            
            timer.invalidate()
            self.executeSearch(term: event.term, withStockKit: stockKit)
        }
    }
    
    func executeSearch(
        term: String,
        withStockKit kit: StockKitComponent) {
        
        kit.fetchStocksFromSearchTerm(term: term)
    }
}

struct GetSearchResultsResponseReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.SearchCompleted
    typealias ReducerState = SearchState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        var sanitizedStocks: [SearchStock] = []
        for item in event.result {
            let keys = item.keys
            if  keys.contains(SearchStockKeys.countryCode.rawValue),
                keys.contains(SearchStockKeys.issueType.rawValue),
                keys.contains(SearchStockKeys.symbolName.rawValue),
                keys.contains(SearchStockKeys.companyName.rawValue),
                keys.contains(SearchStockKeys.exchangeName.rawValue)
                {
                    
                    if item[SearchStockKeys.countryCode.rawValue] == state.validCountryCode, item[SearchStockKeys.issueType.rawValue] == state.validIssueType {
                        
                        
                        let searchStock: SearchStock = .init(
                            exchangeName: item[SearchStockKeys.exchangeName.rawValue],
                            symbolName: item[SearchStockKeys.symbolName.rawValue],
                            companyName: item[SearchStockKeys.companyName.rawValue])
                        
                        sanitizedStocks.append(searchStock)
                    }
                
            }
        }
        
        if sanitizedStocks.count > 0 {
            state.stockResultsActive = true
        } else {
            state.stockResultsActive = false
        }
        state.stocks = sanitizedStocks
    }

}
