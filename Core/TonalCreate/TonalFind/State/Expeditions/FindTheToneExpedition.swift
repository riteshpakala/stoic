//
//  StockHistoryExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct FindTheToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalFindEvents.Find
    typealias ExpeditionState = TonalFindState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
//        state.stage = .find
        print("{TEST} on appear")
        
        //DEV:
        // Need to also check for last trading day
        // update the cache from last date saved to the recent day
        // requested on
        //
        guard let ticker = event.ticker else { return }
        if let quote = coreDataInstance.getQuotes()?
            .first(where: { $0.ticker == ticker &&
                    $0.intervalType == SecurityInterval.day.rawValue })
            .map({ $0.asQuote }) {
            
            connection.dependency(\TonalCreateDependency.tone.find.quote, value: quote)
            
            connection.request(TonalFindEvents.Parse(quote, days: state.days))
        } else {
            connection.request(StockEvents.GetStockHistory.init(ticker: ticker), beam: true)
        }
    }
}

struct StockHistoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.History
    typealias ExpeditionState = TonalFindState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let stocks = event.data.first?.asStocks(interval: event.interval) else {
            return
        }
        
        stocks.save(moc: coreDataInstance) { quote in
            if let object = quote?.asQuote {
                connection.dependency(\TonalCreateDependency.tone.find.quote, value: object)
                connection.request(TonalFindEvents.Parse(object, days: state.days))
            }
        }
    }
}
