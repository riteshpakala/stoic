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
            ThinkResponseReducer.Reducible(),
            PredictionDidUpdateReducer.Reducible(),
            LoadOfflineReducer.Reducible()
        ]
    }
    
    var stockKit: StockKitComponent? {
        return getSubComponent(StockKitComponent.self) as? StockKitComponent
    }
    
    override public func didLoad() {
        push(
            StockKitBuilder.build(
            state: .init(
                sentimentStrength: service.storage.get(
                    GlobalDefaults.SentimentStrength.self),
                predictionDays: service.storage.get(
                    GlobalDefaults.PredictionDays.self)),
            self.service))
        
        
        stockKit?.prepare()
        
        //Onboarding
        if !service.center.onboardingDetailCompleted {
            push(OnboardingBuilder.build(
                self.service,
                state: .init(GlobalDefaults.OnboardingDetail)),
                 display: .fit)
        }
    }
    
    override public func rip() {
        super.rip()
        
        state.scraper.cancel()
    }
}
