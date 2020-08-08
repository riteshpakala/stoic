//
//  GetCSVReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct GetCSVReducer: Reducer {
    typealias ReducerEvent = DetailEvents.GetCSV
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        
        state.csvDownloadTimer?.invalidate()
        state.csvDownloadTimer = nil
        guard let stockKit = component.getSubComponent(
            StockKitComponent.self) as? StockKitComponent else {
            return
        }
        
        state.csvDownloadTimer = Timer.scheduledTimer(
            withTimeInterval: state.csvDelay,
            repeats: false) { timer in
            
            timer.invalidate()
            self.executeDownload(
                ticker: event.ticker,
                withStockKit: stockKit)
        }
    }
    
    func executeDownload(
        ticker: String,
        withStockKit kit: StockKitComponent) {
        
        print("{TEST} execute download \(ticker)")
        kit.getCSV(forTicker: ticker)
    }
}

struct GetCSVProgressResponseReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.CSVProgress
    typealias ReducerState = DetailState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.progressLabelText = "\(Int(round(event.fraction*100)))%"
    }
}

struct GetCSVResultsResponseReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.CSVDownloadCompleted
    typealias ReducerState = DetailState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.csvDownloadTimer = nil
        state.stockData = event.result
        state.predictionState = DetailView.DetailPredictionState.seekingSentiment.rawValue
        
        sideEffects.append(
            .init(
                event: DetailEvents.GetSentiment(
                    ticker: state.searchedStock.symbol)))
    }
}
