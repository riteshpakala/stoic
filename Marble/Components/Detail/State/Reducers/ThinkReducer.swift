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
        
        guard let stockKit = (component as? DetailComponent)?.stockKit else {
            return
        }
        
        guard let payload = state.consoleDetailPayload else {
            return
        }
        
        guard let components = payload.currentTradingDay.asDate()?.dateComponents() else {
            return
        }
        
        state.predictionState = DetailView.DetailPredictionState.thinking.rawValue
        
        stockKit.getValidMarketDays(forMonth: String(components.month), forYear: String(components.year), target: component)
    }
}

struct ThinkGotValidTradingDaysReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.ValidMarketDaysCompleted
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let stockKit = (component as? DetailComponent)?.stockKit else {
            return
        }
        
        guard let payload = state.consoleDetailPayload else {
            return
        }
        
        guard let components = payload.currentTradingDay.asDate()?.dateComponents() else {
            return
        }
        
        let validDays = event.result.filter { $0.isOpen }
        let upcomingDates = validDays.filter { $0.dateComponents.month > components.month || ($0.dateComponents.month == components.month && $0.dateComponents.day > components.day) || ($0.dateComponents.year > components.year) }
        
        guard let nextDate = upcomingDates.sorted(by: { ($0.asDate ?? Date()).compare(($1.asDate ?? Date())) == .orderedAscending } ).first else {
            return
        }
        
        guard let lastPrediction = state.lastPrediction else { return }
        
        guard let models = StockKitModels.appendADay(models: payload.model, stockData: payload.historicalTradingData, sentimentData: lastPrediction.sentimentWeights, tradingDay: payload.currentTradingDay) else { return }
        
        state.stockSentimentData?.append(lastPrediction.sentimentWeights)
        state.model = models.1
        
        var validTradingData = state.consoleDetailPayload?.historicalTradingData ?? []
        validTradingData.append(models.0)//LEFT OFF:::::
        
        let newPayload = ConsoleDetailPayload.init(currentTradingDay: nextDate.asString, historicalTradingData: validTradingData, stockSentimentData: state.stockSentimentData ?? [], days: state.originalDaysTrained ?? stockKit.state.rules.days, maxDays:  stockKit.state.rules.maxDays, model: models.1)
        
        state.consoleDetailPayload = newPayload
        
        sideEffects.append(EventBox.init(event: DetailEvents.ThinkResponse.init(payload: .init(payload: newPayload))))
    }
}

//Old version which gets most recent tweet
//
//struct ThinkReducer: Reducer {
//    typealias ReducerEvent = DetailEvents.Think
//    typealias ReducerState = DetailState
//
//    func reduce(
//        event: ReducerEvent,
//        state: inout ReducerState,
//        sideEffects: inout [EventBox],
//        component: inout Component<ReducerState>) {
//
//        guard component.service.center.isOnline else {
//            state.predictionState = DetailView.DetailPredictionState.offline.rawValue
//            return
//        }
//
//        state.predictionState = DetailView.DetailPredictionState.thinking.rawValue
//
//        let companyName = state.searchedStock.companyName
//        let symbolName = state.searchedStock.symbolName
//        let companyHashtag = companyName != nil ? "#"+companyName!.strip : ""
//        let symbolHashtag = symbolName != nil ? "#"+symbolName!.strip : ""
//
//        let payload: StockSearchPayload =
//            .init(
//                ticker: state.searchedStock.symbol,
//                companyHashtag: companyHashtag,
//                companyName: (companyName ?? "").strip,
//                symbolHashtag: symbolHashtag,
//                symbolName: (symbolName ?? "").strip)
//
//
////        state.consoleDetailPayload?.currentTradingDay
//        guard let stockKit = component.getSubComponent(
//            StockKitComponent.self) as? StockKitComponent else {
//            return
//        }
//
//        guard stockKit.state.isPrepared else {
//            stockKit.prepare()
//            return
//        }
//
//        let theDetailDate = stockKit.state.currentDate
//
//        guard let aheadDate = stockKit.state.advanceDate1Day(
//            date: theDetailDate,
//            value: 1) else {
//            return
//        }
//
//        var sentimentData: [VaderSentimentOutput] = []
//        var tweetData: [Tweet] = []
//
//        print("{TEST} \(theDetailDate.asString) \(aheadDate.asString)")
//        state.oracle.begin(
//            using: payload,
//            since: theDetailDate.asString,
//            until: theDetailDate.asString,
//            count: 1,
//            langCode: PredictionRules().baseLangCode,
//            immediate: true,
//            success:  {[weak component] (results) in
//                for result in results{
//                    tweetData.append(result.0)
//                    sentimentData.append(result.1)
//                    print("{SENTIMENT} \(result.1.asString)")
//                }
//
//                let stockSentiment: StockSentimentData = .init(
//                    date: theDetailDate,
//                    dateAsString: aheadDate.asString,
//                    stockDateRefAsString: theDetailDate.asString,
//                    sentimentData: sentimentData,
//                    tweetData: tweetData)
//
//                component?.sendEvent(
//                    DetailEvents.ThinkResponse.init(
//                        payload: .init(
//                            sentiment: stockSentiment)))
//            },
//            failure: { error in
//                print("{OFFLINE} \(error)")
//            })
//    }
//}

struct ThinkResponseReducer: Reducer {
    typealias ReducerEvent = DetailEvents.ThinkResponse
    typealias ReducerState = DetailState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.predictionState = DetailView.DetailPredictionState.done.rawValue
//        state.thinkPayload = event.payload
    }
}
