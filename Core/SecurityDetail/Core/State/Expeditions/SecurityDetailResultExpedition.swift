//
//  SecurityDetailResultExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct StockDetailResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.History
    typealias ExpeditionState = SecurityDetailState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("relaying stock quotes\nself: \(String(describing: self))", .expedition, focus: true)
        
        let stocks = event.data
        
        let quote = stocks.save(moc: coreDataInstance)
        
        state.quote = quote
    }
}

struct CryptoDetailResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = CryptoEvents.History
    typealias ExpeditionState = SecurityDetailState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        GraniteLogger.info("relaying crypto quotes\nself: \(String(describing: self))", .expedition, focus: true)
        
        let crypto = event.data
        
        let quote = crypto.save(moc: coreDataInstance)
        
        state.quote = quote
    }
}
