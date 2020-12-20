//
//  StockState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class StockState: GraniteState {

}

public class StockCenter: GraniteCenter<StockState> {
    let clockRelay = ClockRelay(StockEvents.UpdateStockData())
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            TradingDayExpedition.Discovery(),
            UpdateStockDataExpedition.Discovery(),
            NewStockDataExpedition.Discovery()
        ]
    }
    
    public enum APIKeys {
        case yahoo(url: String)
    }
    
}

