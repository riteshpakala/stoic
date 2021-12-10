//
//  SearchEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct SearchEvents {
    public struct Query: GraniteEvent {}
    public struct Result: GraniteEvent {
        var securities: [Security]
    }
}
