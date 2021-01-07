//
//  SearchTheToneExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

//struct SearchTheToneExpedition: GraniteExpedition {
//    typealias ExpeditionEvent = StockEvents.SearchResult
//    typealias ExpeditionState = TonalFindState
//    
//    func reduce(
//        event: ExpeditionEvent,
//        state: ExpeditionState,
//        connection: GraniteConnection,
//        publisher: inout AnyPublisher<GraniteEvent, Never>) {
//        
//        print("{TEST} \(event.result.count)")
//        
//        connection.dependency(\TonalCreateDependency.search.securities, value: event.result)
//        
//        state.securityData = event.result
//    }
//}
