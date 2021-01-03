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
    typealias ExpeditionState = AssetSectionState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        switch state.windowType {
        case .topVolume:
            state.securityData = event.topVolume
        case .winners:
            state.securityData = event.gainers
        case .losers:
            state.securityData = event.losers
        default:
            state.securityData = []
        }
        
        state.payload = .init(object: state.securityData)
    }
}
