//
//  SearchComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class SearchComponent: Component<SearchState> {
    override public var reducers: [AnyReducer] {
        [
            GetSearchResultsReducer.Reducible(),
            GetSearchResultsResponseReducer.Reducible()
        ]
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
    }
}
