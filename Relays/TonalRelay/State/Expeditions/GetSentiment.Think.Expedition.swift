//
//  GetSentiment.Think.Expedition.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/23/21.
//

import Foundation
import GraniteUI
import SwiftUI
import Combine

struct GetSentimentThinkExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalEvents.Think
    typealias ExpeditionState = TonalState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.oracle.cancel()
        
        let oracle: TonalService.TweetOraclePayload = .init(query: "$"+event.security.ticker,
                                                            fromDate: event.security.date.asString,
                                                            toDate: event.security.date.advanceDate().asString,
                                                            next: nil,
                                                            maxResults: nil,
                                                            sentimentCount: 120,
                                                            lang: "en",
                                                            immediate: false,
                                                            ticker: event.security.ticker)
        
        
        GraniteLogger.info("thinking about \(event.security.name)", .expedition, focus: true)
        
        state.oracle.begin(
            using: oracle,
            success: { (results) in
                GraniteLogger.info("thought about \(results?.count) discussions", .expedition, focus: true)
                var sounds: [TonalSound] = []
                if let items = results {
                    let model: StoicSentimentModel = .init()
                    
                    for item in items {
                        if let prediction = model.predict(item.text) {
                            
    //                        GraniteLogger.info(prediction.asString, .expedition, focus: true)
                            
                            let sound = TonalSound.init(
                                            date: item.createdAt.asDate() ?? .today,
                                            content: item.text,
                                            sentiment: prediction)
                            sounds.append(sound)
                        }
                    }
                }
                
                state.oracle.clean()
                connection.request(TonalEvents.Think.Result.init(sounds: sounds, security: event.security))
            },
            progress: { progress in
                state.oracle.clean()
                connection.request(TonalEvents.Think.Result.init(sounds: [], security: event.security))
            },
            failure: { (error) in
                state.oracle.clean()
                connection.request(TonalEvents.Think.Result.init(sounds: [], security: event.security))
            }
        )
    }
}

struct ThinkSentimentResultExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalEvents.Think
    typealias ExpeditionState = TonalState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
    }

}
