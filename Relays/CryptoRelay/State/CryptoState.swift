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
    var exchange: String = "kraken"
    var max: Int = 12
    
    var cryptoWatch: Cryptowatcher = .init()
    var service: CryptoService = .init()
}

public class CryptoCenter: GraniteCenter<CryptoState> {
//    let clockRelay = ClockRelay(CryptoEvents.GetMovers())
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            GetMoversCryptoExpedition.Discovery(),
            GetCryptoHistoryExpedition.Discovery(),
            GetCryptoSearchExpedition.Discovery(),
            GetCryptoSearchBackendExpedition.Discovery(),
            GetCryptoSearchResultExpedition.Discovery(),
            GetCryptoSearchQuotesExpedition.Discovery(),
        ]
    }
}
