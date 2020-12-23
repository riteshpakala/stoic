//
//  TonalComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalRelay: GraniteRelay {
    @ObservedObject
    public var command: GraniteService<TonalCenter, TonalState> = .init()
    
    public init() {}
    
    public func setup() {}
}
