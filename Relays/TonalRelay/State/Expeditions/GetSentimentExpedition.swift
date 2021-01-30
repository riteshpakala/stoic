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
        
        state.service.soundAggregate.range = event.range
        state.operationQueue.cancelAllOperations()
        state.stage = .searching
        
//        let chunks: [[Date]] = state.service.soundAggregate.dates.chunked(into: state.service.soundAggregate.dates.count/2)
        
        let dates: [Date] = state.service.soundAggregate.dates
        GraniteLogger.info("sentiment dates to process: \(dates.map { $0.simple })\n self: \(String(describing: self))", .expedition)
        if let date = dates.first(where: {
                                    !state.service.soundAggregate.datesIngested.contains($0.simple) }) {
            
            
            let sinceDateChunk = date
            let untilDateChunk = date.advanceDate(value: 1)
            
            connection.request(TonalEvents
                                .ProcessSentiment
                                .init(sinceDate: sinceDateChunk,
                                      untilDate: untilDateChunk,
                                      ticker: event.range.symbol), .contact)
        }
//        for date in dates {
////            let sorted = chunk.sorted(by: { $0.compare($1) == .orderedDescending })
//            let sinceDateChunk = date
//            let untilDateChunk = date.advanceDate(value: 1)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2.randomBetween(4.2)) {
//                connection.request(TonalEvents
//                                    .ProcessSentiment
//                                    .init(sinceDate: sinceDateChunk,
//                                          untilDate: untilDateChunk,
//                                          ticker: event.range.symbol))
//            }
//        }
    }
}

struct ProcessSentimentExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalEvents.ProcessSentiment
    typealias ExpeditionState = TonalState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let days = event.untilDate.daysFrom(event.sinceDate)
        
        GraniteLogger.info("🧘 ingesting: \(event.sinceDate) - \(event.untilDate)\n\(state.service.soundAggregate.datesIngested.count)/\(state.service.soundAggregate.dates.count)\n---\n\(state.service.soundAggregate.datesIngested.map { $0.simple })\n\(state.service.soundAggregate.dates.map { $0.simple }) \n self: \(String(describing: self))", .expedition, focus: true)
        
        publisher = state
            .service
            .getTweets(matching: event.ticker,
                       since: event.sinceDate,
                       until: event.untilDate,
                       count: days*state.dataScale)
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
        state.service.soundAggregate.data.append(tweet)
        
        guard state.service.soundAggregate.isPrepared else {
            
            if let range = state.service.soundAggregate.range {
                connection.request(TonalEvents.GetSentiment.init(range: range), .contact)
            }
            
            return
        }
        
        GraniteLogger.info("🗽 Sentiment is prepared to train\n self: \(String(describing: self))", .expedition, focus: true)
        
        state.stage = .predicting
        
        let results = state.service.soundAggregate.dataResults
        
        //TODO: abstract this out to be focused on social
        //to make way for the other Tonal categories
        let chunks = results.chunked(into: ceil(max(results.count.asDouble/state.modelThreads.asDouble, 1)).asInt)
        
        state.service.soundAggregate.chunks = chunks.count
        
        var currentOps: [BlockOperation] = []
        for (_, chunk) in chunks.enumerated() {
            //Threaded inference
            
            let op: BlockOperation = .init(block: {
                let query = tweet.query
                let model: StoicSentimentModel = .init()
                var sounds: [TonalSound] = []
            
                for result in chunk {
                    if let prediction = model.predict(result.content, matching: query) {
                        
//                        GraniteLogger.info(prediction.asString, .expedition, focus: true)
                        
                        let sound = TonalSound.init(
                                        date: result.date.asDouble.date(),
                                        content: result.content,
                                        sentiment: prediction)
                        sounds.append(sound)
                    }
                }
                
                connection.request(TonalEvents
                                    .TonalSounds
                                    .init(sounds: sounds))
                
            })
            
            currentOps.append(op)
        }
        
        state.operationQueue.addOperations(currentOps, waitUntilFinished: false)
        
        state.operationQueue.addBarrierBlock {
            GraniteLogger.info("🪔 completed processing: \(state.service.soundAggregate.completed.map { $0.simple.asString })\n self: \(String(describing: self))", .expedition, focus: true)
        }
    }
}

struct TonalSoundsExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalEvents.TonalSounds
    typealias ExpeditionState = TonalState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        state.service.soundAggregate.completed.append(event.sounds.first?.date.simple ?? Date.today)
        state.service.soundAggregate.sounds.append(event.sounds)
        
        GraniteLogger.info("tonal progress: \(state.sentimentProgress) \n self: \(String(describing: self))", .expedition, focus: true)
        
        if state.sentimentProgress >= 1.0 && state.stage != .compiling {
            
            GraniteLogger.info("compiling sentiment\n self: \(String(describing: self))", .expedition, focus: true)
            
            let compiled = state.service.soundAggregate.compiled
            state.service.reset()
            state.stage = .compiling
            let sentiment: TonalSentiment = .init(compiled)
            state.stage = .none
            connection.request(TonalEvents.History.init(sentiment: sentiment))
        }
    }
}
