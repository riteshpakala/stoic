//
//  DiscussComponent.swift
//  stoic
//
//  Created by Ritesh Pakala on 1/30/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct DiscussComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<DiscussCenter, DiscussState> = .init()
    
    public init() {}
    public var body: some View {
        VStack {}
    }
}
