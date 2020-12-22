//
//  StockCryptoExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//
import GraniteUI
import SwiftUI
import Combine

struct MoversStockExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StockEvents.GlobalCategoryResult
    typealias ExpeditionState = AssetGridState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.securityData = event.topVolume
        state.payload = .init(object: state.securityData)
    }
}
