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
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    let tonalRelay: TonalRelay = .init()
    
    var stage: TonalCreateStage = .none {
        didSet {
            print("{TEST} \(stage)")
        }
    }
    
    public init(_ stage: TonalCreateStage) {
        self.stage = stage
    }
    
    required init() {
        self.stage = .none
    }
}

public class TonalCreateCenter: GraniteCenter<TonalCreateState> {
    var envDependency: EnvironmentDependency {
        self.hosted.env
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        []
    }
}
