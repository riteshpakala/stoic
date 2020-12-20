//
//  StockEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct StockEvents {
    public struct StockTradingDay: GraniteEvent {
    }
    
    public struct UpdateStockData: GraniteEvent {
    }
    
    public struct NewStockData: GraniteEvent {
        let data: [StockData]
    }
}

