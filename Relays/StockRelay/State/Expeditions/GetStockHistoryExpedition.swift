//
//  GetStockHistoryExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetStockHistoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.GetStockHistory
    typealias ExpeditionState = StockState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let todaysDate: Date = Date.today
        let testDate: Date = Date.today.advanceDate(value: -1*abs(event.daysAgo))
        
        print("{TEST} hey")
        publisher = state
            .service
            .getStock(matching: event.symbol,
                             from: "\(Int(testDate.timeIntervalSince1970))",//"1591833600",
                             to: "\(Int(todaysDate.timeIntervalSince1970))")
            .replaceError(with: [])
            .map { StockEvents.StockHistory(data: $0) }
            .eraseToAnyPublisher()
    }
}
