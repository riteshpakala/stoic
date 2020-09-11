//
//  SubscribeEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import StoreKit

struct SubscribeEvents {
    public struct GetDisclaimer: Event {
    }
    public struct GetDisclaimerResponse: Event {
        public let disclaimers: [Disclaimer]
    }
    public struct GetProducts: Event {
        let products: [SKProduct]
    }
    public struct SelectedProduct: Event {
        let product: SKProduct
    }
    public struct PurchaseResult: Event {
        let product: ProductID?
        let success: Bool
    }
}
