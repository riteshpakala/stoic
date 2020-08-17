//
//  GetSentimentReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
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
        state.progressLabelText = "\("\"\("What is the world saying about".localized) \(state.searchedStock.companyName ?? state.searchedStock.symbol)?\"")"

        guard let stockKit = component.getSubComponent(
            StockKitComponent.self) as? StockKitComponent else {
            return
        }
        
        let companyName = state.searchedStock.companyName
        let symbolName = state.searchedStock.symbolName
        state.sentimentDownloadTimer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: false) { timer in

            timer.invalidate()
            self.executeDigest(
                ticker: event.ticker,
                companyName: companyName,
                symbolName: symbolName,
                withStockKit: stockKit)
        }
    }
    
    func executeDigest(
        ticker: String,
        companyName: String?,
        symbolName: String?,
        withStockKit kit: StockKitComponent) {
        
        let companyHashtag = companyName != nil ? "#"+companyName!.strip : ""
        let symbolHashtag = symbolName != nil ? "#"+symbolName!.strip : ""
        kit.getSentiment(
            forSearch: .init(
                ticker: ticker,
                companyHashtag: companyHashtag,
                companyName: (companyName ?? "").strip,
                symbolHashtag: symbolHashtag,
                symbolName: (symbolName ?? "").strip))
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
        
//        let condensedText: String? = event.text?
//            .enumerated().map {
//            if $0.offset < 48 {
//                return String($0.element)
//            } else {
//                return ""
//            }
//        }.joined().trailingSpacesTrimmed
        
        //let sentiment = "\"\(condensedText ?? "\("What is the world saying about".localized) \(state.searchedStock.companyName ?? state.searchedStock.symbol)")\((condensedText != nil && (condensedText?.count ?? 0) < (event.text?.count ?? 0)) ? "..." : "")\"\n\n"
        let percent = "\(Int(round(event.fraction*100)))% complete"
        state.progressLabelText = percent
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
