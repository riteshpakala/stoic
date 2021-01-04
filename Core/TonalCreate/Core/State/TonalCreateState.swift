//
//  TonalCreateState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum TonalCreateStage {
    case none
    case find
    case set
    case tune
}

public class TonalCreateState: GraniteState {
    var stage: TonalCreateStage = .none {
        didSet {
            print("{TEST} \(stage)")
        }
    }
    
    var sentimentLoadingProgress: Double = 0.0
    
    var tone: Tone = .init()
    
    public init(_ stage: TonalCreateStage) {
        self.stage = stage
    }
    
    required init() {
        self.stage = .none
    }
}

public class TonalCreateCenter: GraniteCenter<TonalCreateState> {
    private var toneExpeditions: [GraniteBaseExpedition] {
        switch state.stage {
        case .tune:
            return [TuneTheToneExpedition.Discovery(),
                    TonalSentimentHistoryExpedition.Discovery()]
        default:
            return []
        }
        
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        toneExpeditions
    }
}
