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
        let companyName = state.searchedStock.companyName
        let symbolName = state.searchedStock.symbolName
        let companyHashtag = companyName != nil ? "#"+companyName!.strip : ""
        let symbolHashtag = symbolName != nil ? "#"+symbolName!.strip : ""
        
        print("{TEST} wowowow")
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
        
        let theDetailDate = stockKit.state.currentDate
        
        guard let aheadDate = stockKit.state.advanceDate1Day(
            date: theDetailDate,
            value: 1) else {
            return
        }
        
        var sentimentData: [VaderSentimentOutput] = []
        var tweetData: [Tweet] = []
        
        state.scraper.begin(
            using: payload,
            username: nil,
            near: nil,
            since: stockKit.state.dateAsString(date: theDetailDate),
            until: stockKit.state.dateAsString(date: aheadDate),
            count: 1,
            filterLangCode: PredictionRules().baseLangCode,

        success:  {[weak component] (results, reponse) in
            for result in results {
                let vaderSentiment = VaderSentiment.predict(result.text)
                if vaderSentiment.compound != .zero {
                    sentimentData.append(vaderSentiment)
                    tweetData.append(result)
                }
            }
            
            let stockSentiment: StockSentimentData = .init(
                date: theDetailDate,
                dateAsString: stockKit.state.dateAsString(date: aheadDate),
                stockDateRefAsString: stockKit.state.dateAsString(date: theDetailDate),
                dateComponents: theDetailDate.dateComponents(),
                sentimentData: sentimentData,
                tweetData: tweetData)
            
            component?.sendEvent(
                DetailEvents.ThinkResponse.init(
                    payload: .init(
                        sentiment: stockSentiment)))
        }, progress: { text, count in

        },
        failure: {  error in

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

        print("{THINK}")
        state.thinkPayload = event.payload
    }
}
