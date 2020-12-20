//
//  AssetGridNewStocks.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct AssetGridNewStockDataExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.NewStockData
    typealias ExpeditionState = AssetGridState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
    
        
        state.stockData = event.data
        state.payload = .init(object: event.data)
        
        print("{TEST} grid stocks updated \(event.data.count)")
    }
    
}
