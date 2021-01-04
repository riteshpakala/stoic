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
        
        let chunks: [[Date]] = state.service.soundAggregate.dates.chunked(into: state.service.soundAggregate.dates.count/2)
        
        for chunk in chunks {
            let sorted = chunk.sorted(by: { $0.compare($1) == .orderedDescending })

            guard let sinceDateChunk = sorted.last,
                  let untilDateChunk = sorted.first?.advanceDate(value: 1) else { return }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2.randomBetween(1.6)) {
                connection.request(TonalEvents
                                    .ProcessSentiment
                                    .init(sinceDate: sinceDateChunk,
                                          untilDate: untilDateChunk,
                                          ticker: event.range.ticker))
            }
        }
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
        
        let days = abs(event.untilDate.timeIntervalSince(event.sinceDate).date().dateComponents().day)
        
            print(event.sinceDate)
            print(event.untilDate)
        publisher = state
            .service
            .getTweets(matching: event.ticker, since: event.sinceDate, until: event.untilDate, count: days*state.dataScale)
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
        
        state.stage = .predicting
        
        //TODO: abstract this out to be focused on social
        //to make way for the other Tonal categories
        let chunks = tweet.result.chunked(into: ceil(tweet.result.count.asDouble/state.modelThreads.asDouble).asInt)
        
        print("starting \(chunks.count)")
        print("\(tweet.result.map { $0.date.asDouble.date().asString }.uniques)")
        
        var currentOps: [BlockOperation] = []
        for (index, chunk) in chunks.enumerated() {
            //Threaded inference
            
            let op: BlockOperation = .init(block: {
                let query = tweet.query
                let model: StoicSentimentModel = .init()
                var sounds: [TonalSound] = []
            
            
                for result in chunk {
                        if let prediction = model.predict(result.content, matching: query) {

                            sounds.append(TonalSound.init(
                                                date: result.date.asDouble.date(),
                                                content: result.content,
                                                sentiment: prediction))
                            
//                            print("{TEST} updated thread \(index + 1)")
                        }
                }

                connection.request(TonalEvents
                                    .TonalSounds
                                    .init(sounds: sounds),
                                   queue: .main)
                
            })
            
            currentOps.append(op)
        }
        
        state.operationQueue.addOperations(currentOps, waitUntilFinished: false)
        
    }
    
    var thread: DispatchQueue {
        DispatchQueue.init(label: "tonal.relay.predict",
                           qos: .utility,
                           attributes: .concurrent,
                           autoreleaseFrequency: .workItem)
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
        
        state.service.soundAggregate.sounds.append(event.sounds)
        
        print("Sentiment prediction progress: \(state.sentimentProgress)")
        if state.sentimentProgress >= 1.0 && state.stage != .compiling {
            print("compiling")
            let compiled = state.service.soundAggregate.compiled
            state.service.reset()
            state.stage = .compiling
            let sentiment: TonalSentiment = .init(compiled)
            state.stage = .none
            connection.request(TonalEvents.History.init(sentiment: sentiment), beam: true)
        }
    }
}
