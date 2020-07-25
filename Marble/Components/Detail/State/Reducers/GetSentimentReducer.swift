//
//  GetSentimentReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

struct GetSentimentReducer: Reducer {
    typealias ReducerEvent = DetailEvents.GetSentiment
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.sentimentDownloadTimer?.invalidate()
        state.sentimentDownloadTimer = nil
        
        guard let stockKit = component.getSubComponent(
            StockKitComponent.self) as? StockKitComponent else {
            return
        }
        
        state.sentimentDownloadTimer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: false) { timer in

            timer.invalidate()
            self.executeDigest(
                ticker: event.ticker,
                withStockKit: stockKit)
        }
    }
    
    func executeDigest(
        ticker: String,
        withStockKit kit: StockKitComponent) {
        
        kit.getSentiment(forTicker: ticker)
    }
}

struct GetSentimentProgressResponseReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.SentimentProgress
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let sentiment = "[+: \(Int(round((event.sentiment?.posAverage ?? 0)*100)))%] ~ [-: \(Int(round((event.sentiment?.negAverage ?? 0)*100)))%]\n"
        let percent = "\(Int(round(event.fraction*100)))% complete"
        state.progressLabelText = sentiment+percent
    }
}

struct GetSentimentResponseReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.SentimentDigetsCompleted
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.sentimentDownloadTimer = nil
        state.stockSentimentData = event.result
        state.predictionState = DetailView.DetailPredictionState.predicting.rawValue
        
        sideEffects.append(
            .init(
                event: DetailEvents.GetPrediction(),
                async: DispatchQueue.init(label: "prediction-queue")))
    }
}
