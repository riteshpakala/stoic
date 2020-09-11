//
//  BrowserComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class BrowserComponent: Component<BrowserState> {
    override public var reducers: [AnyReducer] {
        [
            StockKitPreparedTradingDayReducer.Reducible(),
            BaseModelSelectedReducer.Reducible(),
            CompiledModelCreationStatusUpdatedReducer.Reducible(),
            ModelToMergeReducer.Reducible(),
            MergeModelReducer.Reducible(),
            StandaloneModelSelectedReducer.Reducible(),
            MergedModelSelectedReducer.Reducible()
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
    }
}
