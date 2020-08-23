//
//  StockKitBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

class StockKitBuilder {
    static func build(
        state: StockKitState = .init(),
        _ services: Services,
        parent: AnyComponent? = nil) -> StockKitComponent {
        return StockKitComponent(
            services,
            state,
            nil,
            parent: parent)
    }
}
