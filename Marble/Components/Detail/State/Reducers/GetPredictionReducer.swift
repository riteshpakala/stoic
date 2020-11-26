//
//  GetPredictionReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import Firebase

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

        guard let validTradingDateData = stockKit.state.validTradingDays else { return }

        let validTradingDays: [String] = validTradingDateData.map { $0.asString }

//        let validSentiments: [StockSentimentData] = stockSentimentData.filter { validTradingDays.contains($0.dateAsString) }
//
//        let validSentimentTradingDays: [String] = validSentiments.map { $0.dateAsString }
        
        let validTradingData: [StockData] = stockData.filter( { validTradingDays.contains($0.dateData.asString) })
        
        state.model = stockKit.predict(
            withStockData: validTradingData,
            stockSentimentData: stockSentimentData)
        
        // { CoreData } Insertion
        if let stockDataOfTradingDay = stockKit.state.nextValidTradingDay,
            let models = state.model {

            let id = component.service.center.saveStockPredictions(
                .init(
                    date: stockDataOfTradingDay,
                    models: models,
                    stock: state.searchedStock,
                    sentimentStrength: stockKit.state.rules.tweets,
                    predictionDays: stockKit.state.rules.days,
                    sentimentData: stockSentimentData,
                    historicalData: validTradingData),
                with: .background)
            
            state.modelID = id
        }
        
        // { ConsoleDetail } Update UI for prediction
        if let model = state.model {
            state.consoleDetailPayload = ConsoleDetailPayload.init(
                currentTradingDay: stockKit.state.nextValidTradingDay?.asString ?? "",
                historicalTradingData: validTradingData,
                stockSentimentData: stockSentimentData,
                days: state.originalDaysTrained ?? stockKit.state.rules.days,
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

struct PredictionDidUpdateReducer: Reducer {
    typealias ReducerEvent = DetailEvents.PredictionDidUpdate
    typealias ReducerState = DetailState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let stockKit = (component as? DetailComponent)?.stockKit else {
            return
        }
        
        let sorted = state.stockData?.sorted(by: {
            ($0.dateData.asDate ?? Date()).compare($1.dateData.asDate ?? Date()) == .orderedDescending })
        
        
        let tradingDay = state.isCached ? state.consoleDetailPayload?.currentTradingDay : stockKit.state.nextValidTradingDay?.asString
        if  let nextTradingDay = tradingDay {
            
            let predictionUpdate: PredictionUpdate = .init(
                sentimentStrength: component.service.storage.get(GlobalDefaults.SentimentStrength.self),
                predictionDays: component.service.storage.get(GlobalDefaults.PredictionDays.self),
                stock: state.searchedStock,
                sentimentWeights: event.stockSentimentData,
                nextTradingDay: nextTradingDay,
                thisTradingDay: sorted?.first?.dateData.asString ?? nextTradingDay,
                close: event.close,
                id: state.modelID ?? "")
            
            state.lastPrediction = predictionUpdate
            
            if let id = Auth.auth().currentUser?.uid {
                //TODO: better prediction tracking
//                component.service.center.backend.put(
//                    predictionUpdate,
//                    route: .global,
//                    server: .prediction,
//                    key: id+"/"+predictionUpdate.key)
            }
        }
        
        state.predictionDidUpdate %= 4
        state.predictionDidUpdate += 1
        
        print("{TEST} \(state.hasMoved)")
        if !state.hasMoved {
            state.newTranslation = .init(
                x: 0,
                y: -DetailStyle.consoleSizeExpanded.height/4)
            state.lastTranslation = state.newTranslation
            state.hasMoved = true
        }
    }
}
