//
//  ExperienceEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct ExperienceRelayEvents {
    public struct Request: GraniteEvent {
        var payload: GranitePayload?
        var target: WindowType
    }
    public struct Forward: GraniteEvent {
        var payload: GranitePayload?
        var target: WindowType
    }
}
