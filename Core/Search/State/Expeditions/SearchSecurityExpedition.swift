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
        
//        connection.request(StockEvents.Search("msft"))
        state.isEditing = true
        
        let type = state.securityType
        let query = state.query
        state.searchTimer = Timer.scheduledTimer(
            withTimeInterval: 1.2.randomBetween(2.4),
            repeats: false) { [weak connection] timer in

            timer.invalidate()
            
            switch type {
            case .stock:
                connection?.request(StockEvents.Search(query))
            case .crypto:
                connection?.request(CryptoEvents.Search(query))
            default:
                break
            }
        }
    }
}
