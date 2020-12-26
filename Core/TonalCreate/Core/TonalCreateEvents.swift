//
//  TonalCreateEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct TonalCreateEvents {
    struct Set: GraniteEvent {
        let ticker: String
        public init(_ ticker: String) {
            self.ticker = ticker
        }
    }
    
    struct Find: GraniteEvent {
        let quote: QuoteObject
        public init(_ quote: QuoteObject) {
            self.quote = quote
        }
    }
}
