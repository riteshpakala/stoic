//
//  DetailComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

public class DetailComponent: Component<DetailState> {
    
    override var reducers: [AnyReducer] {
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
            StockKitIsPreparedReducer.Reducible()
        ]
    }
    
    var stockKit: StockKitComponent? {
        return getSubComponent(StockKitComponent.self) as? StockKitComponent
    }
    
    override func didLoad() {
        push(
            StockKitBuilder.build(
                self.services,
                parent: self))
        
        
        stockKit?.prepare()
    }
}
