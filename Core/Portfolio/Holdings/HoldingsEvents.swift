//
//  HoldingsEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct HoldingsEvents {
    public struct Get: GraniteEvent {}
    public struct Update: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    public struct UpdateComplete: GraniteEvent {}
    public struct Push: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
}
