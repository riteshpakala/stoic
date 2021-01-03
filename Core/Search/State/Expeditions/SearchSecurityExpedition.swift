//
//  SearchSecurityExpeditionExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct SearchSecurityExpedition: GraniteExpedition {
    typealias ExpeditionEvent = SearchEvents.Query
    typealias ExpeditionState = SearchState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.searchTimer?.invalidate()
        state.searchTimer = nil
        print("{TEST} \(event.query)")
        guard event.query.isNotEmpty else { return }
        
        state.searchTimer = Timer.scheduledTimer(
            withTimeInterval: 0.4.randomBetween(2.4),
            repeats: false) { timer in
            
            timer.invalidate()
            connection.request(StockEvents.Search(event.query), beam: true)
        }
    }
}
