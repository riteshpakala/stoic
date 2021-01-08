//
//  FindTheToneExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/25/20.
//
import Foundation
import GraniteUI
import Combine
import SwiftUI

struct SetTheToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalSetEvents.Set
    typealias ExpeditionState = TonalSetState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
       
        print("{TEST} selected the range \(event.range.dates)")
        connection.dependency(\EnvironmentDependency.tone.selectedRange, value: event.range)
        
        if let tone = connection.depObject(\EnvironmentDependency.tone.find.quote),
           let quote = tone?.getObject(moc: coreDataInstance) {
            event.range.checkSentimentCache(quote, moc: coreDataInstance) { sentimentResult in
                if let sentiment = sentimentResult?.sentiment {
                    connection.dependency(\EnvironmentDependency.tone.tune.sentiment, value: sentiment)
                } else {
                    connection.request(TonalEvents.GetSentiment.init(range: sentimentResult?.missing ?? event.range))
                }
            }
        } else {
            connection.request(TonalEvents.GetSentiment.init(range: event.range))
        }
    }
}

struct TonalSentimentHistoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalEvents.History
    typealias ExpeditionState = TonalSetState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        //DEV: Get hits multiple times, need
        //to understand how it's getting hit so many times
        //in the beam event system part of the Tonal Relay
        //
        print(event.sentiment.stats)
        
        guard let tone = connection.depObject(\EnvironmentDependency.tone),
              let range = tone.selectedRange,
              let quote = tone.find.quote?.getObject(moc: coreDataInstance) else {
            
            return
        }
        print("{TEST} got it")
        event.sentiment.save(range, moc: coreDataInstance) { success in
            if success {
                print("{TEST} wait what")
                range.checkSentimentCache(quote, moc: coreDataInstance) { sentimentResult in
                    if let sentiment = sentimentResult?.sentiment {
                        connection.dependency(\EnvironmentDependency.tone.tune.sentiment, value: sentiment)
                    } else {
                        connection.request(TonalEvents.GetSentiment.init(range: sentimentResult?.missing ?? range))
                    }
                }
            }
        }
    }
}
