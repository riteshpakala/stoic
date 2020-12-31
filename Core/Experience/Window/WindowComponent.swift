//
//  WindowComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct WindowComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<WindowCenter, WindowState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            Text("Window")
        }.frame(
            idealWidth: state.config.style.idealWidth,
            maxWidth: .infinity,
            idealHeight: state.config.style.idealHeight,
            maxHeight: .infinity,
            alignment: .center)
    }
}
