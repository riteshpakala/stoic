//
//  SentimentSliderEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct SentimentSliderEvents {
    struct Value: GraniteEvent {
        let x: Double
        let y: Double
        let isActive: Bool
        let date: Date
    }
}
