//
//  TonalFindEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct TonalFindEvents {
    struct Find: GraniteEvent {
        let ticker: String?
    }
    
    struct Parse: GraniteEvent {
        let quote: Quote
        let days: Int
        
        public init(_ quote: Quote, days: Int){
            self.quote = quote
            self.days = days
        }
        
        public var async: DispatchQueue? {
            DispatchQueue.init(label: "tonal.find.parse.serial")
        }
    }
}
