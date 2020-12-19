//
//  UpdateStockDataExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct UpdateStockDataExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.UpdateStockData
    typealias ExpeditionState = StockState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        print("{TEST} stocks should update")
    }
}
