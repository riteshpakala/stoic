//
//  HomeViewComponent.swift
//  Marble
//
//  Created by Ritesh Pakala on 5/14/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

public class HomeComponent: Component<HomeState> {
    override var reducers: [AnyReducer] {
        [
            SVMStockPredictionReducer.Reducible(),
            TweetSentimentReducer.Reducible()
        ]
    }
}
