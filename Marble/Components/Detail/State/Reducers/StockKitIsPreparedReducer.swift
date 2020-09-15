//
//  StockKitIsPreparedReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/8/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import StoreKit

struct StockKitIsPreparedReducer: Reducer {
    typealias ReducerEvent = StockKitEvents.StockKitIsPrepared
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard state.predictionState != DetailView.DetailPredictionState.thinking.rawValue else {
            if event.success {
                sideEffects.append(.init(event: DetailEvents.Think()))
            }
            return
        }
        
        guard state.shouldPredict else {
            
            if !component.service.center.isOnline {
                state.predictionState = DetailView.DetailPredictionState.offline.rawValue
            }
            
            sideEffects.append(.init(event: DetailEvents.LoadOffline()))
            
            return
        }
        
        guard event.success else {
            state.predictionState = DetailView.DetailPredictionState.offline.rawValue
            return
        }
        
        guard let symbolName = state.searchedStock.symbolName else { return }
        
        //Request Review
        let models: [StockModelObject]? = component.service.center.getStockModels(from: .background)
        if  let count = models?.count,
            count > 0,
            count % ServiceCenter.ReviewalRequest == 0{
        
            SKStoreReviewController.requestReview()
        }
        //
        
        state.predictionState = DetailView.DetailPredictionState.downloadingData.rawValue
        sideEffects.append(
            .init(
                event: DetailEvents.GetCSV(
                    ticker: symbolName)))
    }
}

struct LoadOfflineReducer: Reducer {
    typealias ReducerEvent = DetailEvents.LoadOffline
    typealias ReducerState = DetailState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard !state.shouldPredict else {
            return
        }
        
        state.progressLabelText = nil
        state.predictionState = DetailView.DetailPredictionState.done.rawValue
    }
}
