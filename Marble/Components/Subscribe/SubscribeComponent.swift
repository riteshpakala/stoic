//
//  SubscribeComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class SubscribeComponent: Component<SubscribeState> {
    override public var reducers: [AnyReducer] {
        [
            SubscribeDisclaimerReducer.Reducible(),
            SubscribeDisclaimerResponseReducer.Reducible(),
            SusbcribeProductsReducer.Reducible(),
            SusbcribeSelectedProductReducer.Reducible(),
            SusbcribePurchaseResultReducer.Reducible(),
            UpdateSubscriptionStatusReducer.Reducible()
        ]
    }
    
    override public func didLoad() {
        sendEvent(SubscribeEvents.GetDisclaimer())
        
        StoicProducts.store.requestProducts { [weak self] success, products in
            guard success, let products = products else {
                print("failed")
                return
            }
            
            for product in products {
                print("{TEST} \(product.price)")
            }
            
            self?.sendEvent(SubscribeEvents.GetProducts(products: products))
        }
    }
}
