//
//  DiscussEvents.swift
//  stoic
//
//  Created by Ritesh Pakala on 1/30/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct DiscussEvents {
    public struct Load: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    public struct Send: GraniteEvent {}
}
