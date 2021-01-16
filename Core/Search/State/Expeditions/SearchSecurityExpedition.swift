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
        
        guard state.query.isNotEmpty else { return }
        
        state.searchTimer = Timer.scheduledTimer(
            withTimeInterval: 0.4.randomBetween(2.4),
            repeats: false) { timer in
            
            timer.invalidate()
            
            switch state.securityType {
            case .stock:
                connection.request(StockEvents.Search(state.query))
            case .crypto:
                connection.request(CryptoEvents.Search(state.query))
            default:
                break
            }
            
            //Potential dependency updates
//            connection.dependency(\TonalCreateDependency.search.state.query, value: event.query)
            //
        }
    }
}
