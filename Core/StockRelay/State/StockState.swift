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
    let service: StockService = .init()
}

public class StockCenter: GraniteCenter<StockState> {
//    let clockRelay = ClockRelay(StockEvents.GetMovers())
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            TradingDayExpedition.Discovery(),
            UpdateStockDataExpedition.Discovery(),
            NewStockDataExpedition.Discovery(),
            
            GetMoversStockExpedition.Discovery(),
            MoversDataExpedition.Discovery(),
            MoversStockQuotesExpedition.Discovery()
        ]
    }
    
    public enum APIKeys {
        case yahoo(url: String)
    }
    
}

