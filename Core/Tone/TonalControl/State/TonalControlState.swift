//
//  TonalControlState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/25/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class TonalControlState: GraniteState {
    let tuner: SentimentSliderState
    var currentPrediction: TonalPrediction = .zero
    var model: TonalModel? = nil
    
    public init(_ tuner: SentimentSliderState, model: TonalModel?) {
        self.tuner = tuner
        self.model = model
    }
    
    public required init() {
        tuner = .init(.neutral, date: .today)
        model = nil
    }
}

public class TonalControlCenter: GraniteCenter<TonalControlState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            TonalControlSentimentExpedition.Discovery()
        ]
    }
}
