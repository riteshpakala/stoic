//
//  GetPredictionReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

struct GetPredictionReducer: Reducer {
    typealias ReducerEvent = DetailEvents.GetPrediction
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let stockKit = (component as? DetailComponent)?.stockKit else {
            return
        }
        
        guard let stockDate = state.stockData else { return }
        
        guard let stockSentimentData = state.stockSentimentData else { return }
        
        guard let validTradindDateData = stockKit.state.validTradingDays else { return }
        
        let validTradingDays: [String] = validTradindDateData.map { $0.asString }
        
        let validSentiments: [StockSentimentData] = stockSentimentData.filter { validTradingDays.contains($0.dateAsString) }
        
        let validSentimentTradingDays: [String] = validSentiments.map { $0.dateAsString }
        
        let validTradingData: [StockData] = stockDate.filter( { validSentimentTradingDays.contains($0.dateData.asString) })
        
        //
        
        state.model = stockKit.predict(
            withStockData: validTradingData,
            stockSentimentData: validSentiments)
        
        if let model = state.model {
            state.consoleDetailPayload = ConsoleDetailPayload.init(
                currentTradingDay: stockKit.state.nextValidTradingDay?.asString ?? "",
                historicalTradingData: stockDate,
                stockSentimentData: validSentiments,
                days: stockKit.state.rules.days,
                maxDays: stockKit.state.rules.maxDays,
                model: model)
        }
        
        var outputs : [Double?] = []
        print("{TEST} \(validSentimentTradingDays)")
        for i in 0..<2 {
            let testData = DataSet(dataType: .Regression, inputDimension: 3, outputDimension: 1)
            do {
                try testData.addTestDataPoint(input: [Double(validTradingData.count), 0.5, 0.5])
            }
            catch {
                print("Invalid data set created")
            }

            if i == 0 {
                state.model?.open.predictValues(data: testData)
                print("{TEST} open: \(testData.outputs)")
            } else if i == 1 {
                state.model?.close.predictValues(data: testData)
                print("{TEST} close: \(testData.outputs)")
            }

            outputs.append(testData.outputs?.first?.first)
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
