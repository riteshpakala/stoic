//
//  TonalCompileComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalCompileComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalCompileCenter, TonalCompileState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            
            
           
            
        }.onAppear(perform: {
            if command.center.compileState == .readyToCompile {
                sendEvent(TonalCompileEvents.Compile())
            }
        })
    }
}
