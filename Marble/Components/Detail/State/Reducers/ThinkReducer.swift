//
//  ThinkReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/15/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct ThinkReducer: Reducer {
    typealias ReducerEvent = DetailEvents.Think
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard component.service.center.isOnline else {
            state.predictionState = DetailView.DetailPredictionState.offline.rawValue
            return
        }
        
        state.predictionState = DetailView.DetailPredictionState.thinking.rawValue
        
        let companyName = state.searchedStock.companyName
        let symbolName = state.searchedStock.symbolName
        let companyHashtag = companyName != nil ? "#"+companyName!.strip : ""
        let symbolHashtag = symbolName != nil ? "#"+symbolName!.strip : ""
        
        let payload: StockSearchPayload =
            .init(
                ticker: state.searchedStock.symbol,
                companyHashtag: companyHashtag,
                companyName: (companyName ?? "").strip,
                symbolHashtag: symbolHashtag,
                symbolName: (symbolName ?? "").strip)
        
        
//        state.consoleDetailPayload?.currentTradingDay
        guard let stockKit = component.getSubComponent(
            StockKitComponent.self) as? StockKitComponent else {
            return
        }
        
        guard stockKit.state.isPrepared else {
            stockKit.prepare()
            return
        }
        
        let theDetailDate = stockKit.state.currentDate
        
        guard let aheadDate = stockKit.state.advanceDate1Day(
            date: theDetailDate,
            value: 1) else {
            return
        }
        
        var sentimentData: [VaderSentimentOutput] = []
        var tweetData: [Tweet] = []
        
        print("{TEST} \(theDetailDate.asString) \(aheadDate.asString)")
        state.oracle.begin(
            using: payload,
            since: theDetailDate.asString,
            until: theDetailDate.asString,
            count: 1,
            langCode: PredictionRules().baseLangCode,
            immediate: true,
            success:  {[weak component] (results) in
                for result in results{
                    tweetData.append(result.0)
                    sentimentData.append(result.1)
                    print("{SENTIMENT} \(result.1.asString)")
                }
                
                let stockSentiment: StockSentimentData = .init(
                    date: theDetailDate,
                    dateAsString: aheadDate.asString,
                    stockDateRefAsString: theDetailDate.asString,
                    sentimentData: sentimentData,
                    tweetData: tweetData)
                
                component?.sendEvent(
                    DetailEvents.ThinkResponse.init(
                        payload: .init(
                            sentiment: stockSentiment)))
            },
            failure: { error in
                print("{OFFLINE} \(error)")
            })
    }
}

struct ThinkResponseReducer: Reducer {
    typealias ReducerEvent = DetailEvents.ThinkResponse
    typealias ReducerState = DetailState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.predictionState = DetailView.DetailPredictionState.done.rawValue
        state.thinkPayload = event.payload
    }
}
