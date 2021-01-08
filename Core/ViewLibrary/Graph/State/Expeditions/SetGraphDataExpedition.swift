//
//  SetGraphDataExpedition.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/6/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct SetTheGraphExpedition: GraniteExpedition {
    typealias ExpeditionEvent = GraphEvents.Set
    typealias ExpeditionState = GraphState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        if let quotes = coreDataInstance.getQuotes()?.first(where: {$0.ticker == "MSFT"}) {
            
            state.quote = quotes.asQuote
        }
    }
}
