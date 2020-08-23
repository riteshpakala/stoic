//
//  SubscribeEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

struct SubscribeEvents {
    public struct GetDisclaimer: Event {
    }
    public struct GetDisclaimerResponse: Event {
        public let disclaimers: [Disclaimer]
    }
}
