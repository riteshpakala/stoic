//
//  SubscribeBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

class SubscribeBuilder {
    static func build(
        _ service: Service) -> SubscribeComponent {
        return SubscribeComponent(
            service,
            .init(),
            SubscribeViewController())
    }
}
