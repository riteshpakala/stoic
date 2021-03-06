//
//  ExperienceEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct EnvironmentEvents {
    struct Boot: GraniteEvent {
        var async: DispatchQueue? {
            GraniteThread.event
        }
    }
    struct Broadcasts: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
        var async: DispatchQueue? {
            GraniteThread.event
        }
    }
    struct Variables: GraniteEvent {
        var async: DispatchQueue? {
            GraniteThread.event
        }
    }
}
