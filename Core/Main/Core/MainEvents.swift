//
//  MainEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct MainEvents {
    struct User: GraniteEvent {
        public var behavior: GraniteEventBehavior {
            .quite
        }
    }
    struct Logout: GraniteEvent {}
}
