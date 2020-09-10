//
//  BrowserBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

class BrowserBuilder {
    static func build(
        _ service: Service,
        state: BrowserState) -> BrowserComponent {
        return BrowserComponent(
            service,
            state,
            BrowserViewController())
    }
}
