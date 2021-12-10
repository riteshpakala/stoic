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

public class ClockState: GraniteState {
}

public class ClockCenter: GraniteCenter<ClockState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
}
