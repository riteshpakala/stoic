//
//  TradingDayReducer.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct TradingDayExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.StockTradingDay
    typealias ExpeditionState = StockState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        print("{TEST} \(CFAbsoluteTimeGetCurrent())")
    }
}
