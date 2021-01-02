//
//  ClockState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class CryptoState: GraniteState {
    var currency: String = "usd"
    var exchange: String = "coinbase-pro"
    var max: Int = 12
}

public class CryptoCenter: GraniteCenter<CryptoState> {
//    let clockRelay = ClockRelay(CryptoEvents.GetMovers())
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetMoversCryptoExpedition.Discovery()
        ]
    }
}
