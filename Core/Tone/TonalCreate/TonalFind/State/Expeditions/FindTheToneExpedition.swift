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
        
        //Update the current slider value to the days set
        //before parsing begins.
        let dayDiff: Double = Double(state.maxDays - state.minDays)
        let days: Double = find.sliderDays.number*dayDiff
        state.days = Int(days) + state.minDays
        //
        
        guard stage == .selected else {
            
            if stage == .found,
               let quote = find.quote {
                
                connection.request(TonalFindEvents.Parse(quote, days: state.days))
            }
            
            return
        }
        
        guard let security = find.security else { return }
        
        security.getQuote(moc: coreDataInstance) { quote in
            //DEV: cleaner and the ability to modify the hourly interval
            if let quote = quote,
               !quote.needsUpdate {
                connection.update(\EnvironmentDependency.tone.find.quote, value: quote)
                
            } else {
                switch security.securityType {
                case .crypto:
                    connection.request(CryptoEvents.GetCryptoHistory.init(security: security))
                case .stock:
                    connection.request(StockEvents.GetStockHistory.init(security: security))
                default:
                    break
                }
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

struct CryptoHistoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.History
    typealias ExpeditionState = TonalFindState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let crypto = event.data
        
        crypto.save(moc: coreDataInstance) { quote in
            if let object = quote {
                connection.update(\EnvironmentDependency.tone.find.quote, value: object)
            }
        }
    }
}
