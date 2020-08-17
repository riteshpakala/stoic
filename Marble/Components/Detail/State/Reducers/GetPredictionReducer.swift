//
//  GetPredictionReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct GetPredictionReducer: Reducer {
    typealias ReducerEvent = DetailEvents.GetPrediction
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.progressLabelText = nil
        
        guard let stockKit = (component as? DetailComponent)?.stockKit else {
            return
        }
        
        guard let stockData = state.stockData else { return }
        
        guard let stockSentimentData = state.stockSentimentData else { return }
        
//        guard let validTradindDateData = stockKit.state.validTradingDays else { return }
//
//        let validTradingDays: [String] = validTradindDateData.map { $0.asString }
//
//        let validSentiments: [StockSentimentData] = stockSentimentData.filter { validTradingDays.contains($0.dateAsString) }
//
//        let validSentimentTradingDays: [String] = validSentiments.map { $0.dateAsString }
        
//        let validTradingData: [StockData] = stockDate.filter( { validSentimentTradingDays.contains($0.dateData.asString) })
        
        //
        
        state.model = stockKit.predict(
            withStockData: stockData,
            stockSentimentData: stockSentimentData)
        
        if let model = state.model {
            state.consoleDetailPayload = ConsoleDetailPayload.init(
                currentTradingDay: stockKit.state.nextValidTradingDay?.asString ?? "",
                historicalTradingData: stockData,
                stockSentimentData: stockSentimentData,
                days: stockKit.state.rules.days,
                maxDays: stockKit.state.rules.maxDays,
                model: model)
        }
        
        state.progressLabelText = nil
        state.predictionState = DetailView.DetailPredictionState.done.rawValue
    }
}

struct GetPredictionProgressReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.PredictionProgress
    typealias ReducerState = DetailState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.progressLabelText = "iteration: \(event.iterations)\n--------\n\(event.maxIterations)"
    }
}
