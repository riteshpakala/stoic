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

public enum TonalStage {
    case none
    case find
    case set
    case tune
}

public class TonalCreateState: GraniteState {
    var stage: TonalStage = .none
}

public class TonalCreateCenter: GraniteCenter<TonalCreateState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            
            FindTheToneExpedition.Discovery(),
            StockHistoryExpedition.Discovery(),
            
            SetTheToneExpedition.Discovery(),
            
            TuneTheToneExpedition.Discovery(),
        ]
    }
}
