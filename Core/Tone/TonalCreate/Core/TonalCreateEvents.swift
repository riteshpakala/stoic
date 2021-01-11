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
//    struct Search: GraniteEvent {
//        let query: String
//        public init(_ query: String) {
//            self.query = query
//        }
//    }
    
//    struct Find: GraniteEvent {
//        let ticker: String?
//        public init(_ ticker: String?) {
//            self.ticker = ticker
//        }
//    }
    
    
    
    struct Tune: GraniteEvent {
        let range: TonalRange
        public init(_ range: TonalRange) {
            self.range = range
        }
    }
}
