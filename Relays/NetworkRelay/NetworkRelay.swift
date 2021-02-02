//
//  NetworkRelayComponent.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct NetworkRelay: GraniteRelay {
    @ObservedObject
    public var command: GraniteService<NetworkCenter, NetworkState> = .init()
    public init() {}
    public func setup() {}
}
