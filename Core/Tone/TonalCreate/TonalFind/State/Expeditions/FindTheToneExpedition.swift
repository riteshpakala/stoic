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
        
        
        //DEV:
        // Need to also check for last trading day
        // update the cache from last date saved to the recent day
        // requested on
        //
        guard let find = connection.retrieve(\EnvironmentDependency.tone.find),
              let stage = connection.retrieve(\EnvironmentDependency.tone.find.state) else {
            
            return
        }
        
        guard stage == .selected else {
            
            if stage == .found,
               let quote = find.quote {
                
                connection.request(TonalFindEvents.Parse(quote, days: state.days))
            }
            
            return
        }
        
        guard let security = find.security else { return }
        
        coreDataInstance.getQuotes { result in
            //DEV: cleaner and the ability to modify the hourly interval
            if let quote = result.first(where: { $0.ticker == security.ticker &&
                                                 $0.intervalType == .day }) {
                
                connection.update(\EnvironmentDependency.tone.find.quote, value: quote)
            } else {
                connection.request(StockEvents.GetStockHistory.init(security: security))
            }
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
        
        let stocks = event.data
        
        stocks.save(moc: coreDataInstance) { quote in
            if let object = quote {
                connection.update(\EnvironmentDependency.tone.find.quote, value: object)
            }
        }
    }
}
