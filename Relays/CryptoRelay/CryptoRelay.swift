//
//  ClockRelay.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct CryptoRelay: GraniteRelay {
    @ObservedObject
    public var command: GraniteService<CryptoCenter, CryptoState> = .init()

    public init() {
        setup()
    }
    
    public func setup() {
//        Cryptowatcher().getMarketPrice(exchange: "coinbase-pro", pair: "btcusd").then { response in
//            let price = response.result.price
//            let remainingAllowance = response.allowance.remaining
//
//         // Use the values to do something fun
//        }.onError { error in
//         // Handle the error
//        }
        
    }
}
