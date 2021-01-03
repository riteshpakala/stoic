//
//  ExperienceComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct ExperienceRelay: GraniteRelay {
    @ObservedObject
    public var command: GraniteService<ExperienceRelayCenter, ExperienceRelayState> = .init()
    
    public init() {}
    
    public func setup() {}
}
