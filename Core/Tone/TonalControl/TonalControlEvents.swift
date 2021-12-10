//
//  TonalControlEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/25/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct TonalControlEvents {
    public struct Generate: GraniteEvent {
        var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    public struct Predict: GraniteEvent {
        let sentiment: SentimentOutput
    }
    public struct Prediction: GraniteEvent {
        let data: TonalPrediction
    }
}
