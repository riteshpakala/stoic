//
//  SpecialComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct SpecialComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<SpecialCenter, SpecialState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            state.scene.onAppear(perform: {
                state.scene.run()
            }).onDisappear(perform: {
                state.scene.clear()
            })
        }
    }
}
