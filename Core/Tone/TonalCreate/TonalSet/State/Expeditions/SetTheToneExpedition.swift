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
       
        GraniteLogger.info("tonal range selected:\n\(event.range)\nself:String(describing: self)", .expedition)
        
        connection.update(\EnvironmentDependency.tone.selectedRange, value: event.range)
        
        if let tone = connection.retrieve(\EnvironmentDependency.tone.find.quote) {
            tone?.getObject(moc: coreDataInstance) { quote in
                if let quote = quote {
                    event.range.checkSentimentCache(quote, moc: coreDataInstance) { sentimentResult in
                        if let sentiment = sentimentResult?.sentiment {
                            connection.update(\EnvironmentDependency.tone.tune.sentiment, value: sentiment)
                            connection.update(\EnvironmentDependency.tone.set.stage, value: .none)
                        } else {
                            connection.request(TonalEvents.GetSentiment.init(range: sentimentResult?.missing ?? event.range))
                        }
                    }
                } else {
                    connection.request(TonalEvents.GetSentiment.init(range: event.range))
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
        GraniteLogger.info("sentiment history received & saving\nself:String(describing: self)", .expedition)
        
        guard let tone = connection.retrieve(\EnvironmentDependency.tone),
              let range = tone.selectedRange else {
            
            GraniteLogger.info("sentiment history saving failed \nself:String(describing: self)", .expedition)
            return
        }
        
        let moc = coreDataInstance
        tone.find.quote?.getObject(moc: moc) { quote in
            guard let quote = quote else { return }
            event.sentiment.save(range, moc: moc) { success in
                if success {
                    range.checkSentimentCache(quote, moc: moc) { sentimentResult in
                        if let sentiment = sentimentResult?.sentiment {
                            connection.update(\EnvironmentDependency.tone.tune.sentiment, value: sentiment)
                            connection.update(\EnvironmentDependency.tone.set.stage, value: .none)
                        } else {
                            connection.request(TonalEvents.GetSentiment.init(range: sentimentResult?.missing ?? range))
                        }
                    }
                }
            }
        }
    }
}
