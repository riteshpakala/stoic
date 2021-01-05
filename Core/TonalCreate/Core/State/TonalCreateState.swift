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
    case compile
}

public class TonalCreateState: GraniteState {
    var stage: TonalCreateStage = .none {
        didSet {
            print("{TEST} \(stage)")
        }
    }
    
    var tone: Tone = .init()
    
    public init(_ stage: TonalCreateStage) {
        self.stage = stage
    }
    
    required init() {
        self.stage = .none
    }
}

public class TonalCreateCenter: GraniteCenter<TonalCreateState> {
    public override var expeditions: [GraniteBaseExpedition] {
        []
    }
}
