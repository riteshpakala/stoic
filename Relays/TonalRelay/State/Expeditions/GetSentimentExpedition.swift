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

        if let date = dates.first(where: {
                                    !state.service.soundAggregate.completed.contains($0.simple) }) {
            
            
            let sinceDateChunk = date
            let untilDateChunk = date.advanceDate(value: 1)
            
            connection.request(TonalEvents
                                .ProcessSentiment
                                .init(sinceDate: sinceDateChunk,
                                      untilDate: untilDateChunk,
                                      ticker: event.range.symbol))
        }
//        for date in dates {
////            let sorted = chunk.sorted(by: { $0.compare($1) == .orderedDescending })
//            let sinceDateChunk = date
//            let untilDateChunk = date.advanceDate(value: 1)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2.randomBetween(4.2)) {
//                print("{TEST} processing \(sinceDateChunk) \(untilDateChunk)")
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
        
        let days = abs(event.untilDate.timeIntervalSince(event.sinceDate).date().dateComponents().day)
        
        print("🧘🧘🧘🧘🧘🧘\n[Sentiment] Processing \(event.sinceDate) - \(event.untilDate) \n🧘")
        
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
        let chunks = tweet.result.chunked(into: ceil(max(tweet.result.count.asDouble/state.modelThreads.asDouble, 1)).asInt)
        
        var currentOps: [BlockOperation] = []
        for (_, chunk) in chunks.enumerated() {
            //Threaded inference
            
            let op: BlockOperation = .init(block: {
                let query = tweet.query
                let model: StoicSentimentModel = .init()
                var sounds: [TonalSound] = []
            
            
                for result in chunk {
                    if let prediction = model.predict(result.content, matching: query) {
                        let sound = TonalSound.init(
                                        date: result.date.asDouble.date(),
                                        content: result.content,
                                        sentiment: prediction)
                        sounds.append(sound)
                        
//                        print(sound.asString)
//                        print("{TEST} updated thread \(index)")
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
        
        state.operationQueue.addBarrierBlock {
            print("🪔🪔🪔🪔🪔🪔\n[Sentiment] completed \(tweet.result.map { $0.date.asDouble.date().asString }.uniques)\n🪔")
            if let range = state.service.soundAggregate.range {
                
                connection.request(TonalEvents.GetSentiment.init(range: range), .contact)
            }
        }
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
        
        state.service.soundAggregate.completed.append(event.sounds.first?.date.simple ?? Date.today)
        state.service.soundAggregate.sounds.append(event.sounds)
        
        print("Sentiment prediction progress: \(state.sentimentProgress)")
        if state.sentimentProgress >= 1.0 && state.stage != .compiling {
            print("compiling")
            let compiled = state.service.soundAggregate.compiled
            state.service.reset()
            state.stage = .compiling
            let sentiment: TonalSentiment = .init(compiled)
            state.stage = .none
            connection.request(TonalEvents.History.init(sentiment: sentiment))
        }
    }
}
