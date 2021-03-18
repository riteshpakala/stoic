//
//  AssetInteractionExpedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 3/8/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct TonalModelFavoritedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = AssetGridEvents.AssetTapped
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        switch event.asset.assetType {
        case .model:
            //TODO: set a favorite model here
            print("{TEST} hey i am here")
            break
        default:
            break
        }
    }
}

struct ToneDataRequestedExpedition: GraniteExpedition {
    typealias ExpeditionEvent = StrategyEvents.Tone.Request
    typealias ExpeditionState = StrategyState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        if let quote = state.strategy.getQuoteFor(event.item) {
            
            if let model = TonalModels.generate(fromQuote: quote,
                                                fromDate: event.change.date) {
                
                
                let prediction = model.predictAll()
                print("{TEST} updating")
                event.item.meta.update(prediction, change: event.change)
//                TonalModel.
            }
            
//            if let model = quote.models.first(where: { $0.modelID == modelID }) {
//                
//            }
        }
    }
}
