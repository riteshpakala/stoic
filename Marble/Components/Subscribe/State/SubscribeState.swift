//
//  SubscribeState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import StoreKit

public class SubscribeState: State {
    @objc dynamic var disclaimers: [Disclaimer]? = nil
    @objc dynamic var products: [SKProduct] = []
    @objc dynamic var purchaseResult: PurchaseResult? = nil
    @objc dynamic var isLoading: Bool = true
}

public class PurchaseResult: NSObject {
    let success: Bool
    let productID: ProductID?
    
    public init(_ success: Bool, productID: ProductID?) {
        self.success = success
        self.productID = productID
    }
}
