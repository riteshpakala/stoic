//
//  TonalModelsState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum TonalModelsStage {
    case fetching
    case none
}
public class TonalModelsState: GraniteState {
    var stage: TonalModelsStage
    
    public init(_ stage: TonalModelsStage) {
        self.stage = stage
    }
    
    public required init() {
        self.stage = .none
    }
}

public class TonalModelsCenter: GraniteCenter<TonalModelsState> {
    public override var links: [GraniteLink] {
        [
            .onAppear(TonalModelsEvents.Get(), .dependant),
        ]
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetTonalModelsExpedition.Discovery()
        ]
    }
}
