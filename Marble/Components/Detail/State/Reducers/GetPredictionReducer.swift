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
        
        if let model = state.model {
            state.consoleDetailPayload = ConsoleDetailPayload.init(
                currentTradingDay: stockKit.state.nextValidTradingDay?.asString ?? "",
                historicalTradingData: validTradingData,
                stockSentimentData: stockSentimentData,
                days: stockKit.state.rules.days,
                maxDays: stockKit.state.rules.maxDays,
                model: model)
        }
        
        state.progressLabelText = nil
        state.predictionState = DetailView.DetailPredictionState.done.rawValue
        
        // { CoreData } Insertion
        guard let stockDataOfTradingDay = stockKit.state.nextValidTradingDay,
              let model = state.model?.david,
              let dataSet = state.model?.david.dataSet else {
            return
        }

        component.service.center.saveStockPredictions(
            .init(
                date: stockDataOfTradingDay,
                model: model,
                stock: state.searchedStock,
                sentimentStrength: stockKit.state.rules.tweets,
                predictionDays: stockKit.state.rules.days,
                sentimentData: stockSentimentData,
                historicalData: validTradingData,
                dataSet: dataSet),
            with: .background)
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
        
        if state.predictionDidUpdate >= 4 {
            guard let stockKit = (component as? DetailComponent)?.stockKit else {
                return
            }
            
            if  let id = Auth.auth().currentUser?.uid,
                let nextTradingDay = stockKit.state.nextValidTradingDay?.asString {
                
                let predictionUpdate: PredictionUpdate = .init(
                    sentimentStrength: component.service.storage.get(GlobalDefaults.SentimentStrength.self),
                    predictionDays: component.service.storage.get(GlobalDefaults.PredictionDays.self),
                    stock: state.searchedStock,
                    sentimentWeights: event.stockSentimentData,
                    nextTradingDay: nextTradingDay,
                    close: event.close)
                
                component.service.center.backend.put(
                    predictionUpdate,
                    route: .global,
                    server: .prediction,
                    key: id+"/"+predictionUpdate.key)
            }
        }
        
        state.predictionDidUpdate %= 4
        state.predictionDidUpdate += 1
        
        if state.newTranslation == .zero && state.lastTranslation == .zero {
            state.newTranslation = .init(
                x: 0,
                y: -DetailStyle.consoleSizeExpanded.height/4)
            state.lastTranslation = state.newTranslation
        }
    }
}

        

