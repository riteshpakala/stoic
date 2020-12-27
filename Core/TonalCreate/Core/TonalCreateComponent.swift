//
//  TonalCreateComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalCreateComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalCreateCenter, TonalCreateState> = .init()
    
    public init() {}
    
    public func onCommit() {
        
    }
    
    public var body: some View {
        VStack {
            if (state.stage == .set) {
                TonalSetComponent().payload(state.payload).listen(to: command)
            } else if (state.stage == .tune) {
                
            }
        }.frame(width: 300, height: 500, alignment: .center).onAppear(perform: sendEvent(TonalCreateEvents.Find("MSFT")))
    }
}
