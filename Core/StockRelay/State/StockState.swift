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
    public override var relays: [AnyGraniteRelay] {
        [
            ClockRelay(StockEvents.UpdateStockData(), latch: true)
        ]
    }
}

