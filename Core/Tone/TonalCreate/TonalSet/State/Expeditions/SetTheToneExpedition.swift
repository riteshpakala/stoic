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
       
        GraniteLogger.info("tonal range selected:\n\(event.range.dates) \(event.range.objects.count) \(event.range.expanded.count)\n", .expedition, focus: false)
        
        connection.update(\ToneDependency.tone.selectedRange, value: event.range)
        
        if let tone = connection.retrieve(\ToneDependency.tone.find.quote) {
            if let quote = tone {
                let sentimentResult = event.range.checkSentimentCache(quote, moc: coreDataInstance)
                if let sentiment = sentimentResult?.sentiment {
                    connection.update(\ToneDependency.tone.tune.sentiment, value: sentiment)
                    connection.update(\ToneDependency.tone.set.stage, value: .fetched)
                } else {
                    connection.request(TonalEvents.GetSentiment.init(range: sentimentResult?.missing ?? event.range))
                }
            } else {
                connection.request(TonalEvents.GetSentiment.init(range: event.range))
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
        
        guard let tone = connection.retrieve(\ToneDependency.tone),
              let range = tone.selectedRange else {
            
            GraniteLogger.info("sentiment history saving failed \nself:String(describing: self)", .expedition)
            return
        }
        
        let moc = coreDataInstance
        guard let quote = tone.find.quote else { return }
        let success = event.sentiment.save(range, moc: moc)
        if success {
            let sentimentResult = range.checkSentimentCache(quote, moc: moc)
            if let sentiment = sentimentResult?.sentiment {
                connection.update(\ToneDependency.tone.tune.sentiment, value: sentiment)
                connection.update(\ToneDependency.tone.set.stage, value: .fetched)
            } else {
                connection.request(TonalEvents.GetSentiment.init(range: sentimentResult?.missing ?? range))
            }
        }
    }
}
