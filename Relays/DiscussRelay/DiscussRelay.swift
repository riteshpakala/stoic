//
//  ClockRelay.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct DiscussRelay: GraniteRelay {
    @ObservedObject
    public var command: GraniteService<DiscussRelayCenter, DiscussRelayState> = .init()
    
    public init() {}
    
    public func setup() {}
    public func clean() {
        GraniteLogger.info("clean relay", .event, focus: true)
    }
}
