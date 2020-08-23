//
//  DetailComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class DetailComponent: Component<DetailState> {
    
    override public var reducers: [AnyReducer] {
        [
            DetailLongPressStartedReducer.Reducible(),
            DetailLongPressChangedReducer.Reducible(),
            DetailLongPressEndedReducer.Reducible(),
            GetCSVReducer.Reducible(),
            GetCSVProgressResponseReducer.Reducible(),
            GetCSVResultsResponseReducer.Reducible(),
            GetSentimentReducer.Reducible(),
            GetSentimentProgressResponseReducer.Reducible(),
            GetSentimentResponseReducer.Reducible(),
            GetPredictionReducer.Reducible(),
            GetPredictionProgressReducer.Reducible(),
            StockKitIsPreparedReducer.Reducible(),
            ThinkReducer.Reducible(),
            ThinkResponseReducer.Reducible()
        ]
    }
    
    var stockKit: StockKitComponent? {
        return getSubComponent(StockKitComponent.self) as? StockKitComponent
    }
    
    override public func didLoad() {
        push(
            StockKitBuilder.build(
            state: .init(
                sentimentStrength: services.storage.get(
                    GlobalDefaults.SentimentStrength.self),
                predictionDays: services.storage.get(
                    GlobalDefaults.PredictionDays.self)),
            self.services,
            parent: self))
        
        
        stockKit?.prepare()
    }
}
