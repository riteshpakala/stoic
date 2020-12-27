//
//  GetSentimentExpeditionExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetSentimentExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalEvents.GetSentiment
    typealias ExpeditionState = TonalState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let testDate = event.range.dates.first else { return }
        
        let sinceDate: Date = testDate
            
        let untilDate: Date = sinceDate.advanceDate(value: 1)
        
        print("{TEST} \(sinceDate.asString)")
        publisher = state
            .service
            .getTweets(matching: "$MSFT", since: sinceDate, until: untilDate)
            .replaceError(with: [])
            .map { TonalEvents.TonalHistory(data: $0) }
            .eraseToAnyPublisher()
    }
}

struct TonalHistoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalEvents.TonalHistory
    typealias ExpeditionState = TonalState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        guard let tweet = event.data.first else { return }
        
        print(tweet.result.count)
    }
}
