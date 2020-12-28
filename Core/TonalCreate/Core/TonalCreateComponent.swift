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
    
    
    public init() {
        
    }
    
    var tonalCenter: TonalCenter? {
        relay(TonalRelay.self)?.mirrorMe(TonalCenter.self)
    }
    
    public var body: some View {
        VStack {
            TonalSetComponent().payload(state.payload).listen(to: command)
            
            if (state.stage == .tune) {
                Text("\(state.sentimentLoadingProgress)")
                TonalTuneComponent().payload(state.payload).listen(to: command)
            }
            
//            GraniteLink(
//                relay(TonalRelay.self),
//                \TonalCenter.progress,
//                target: _state.sentimentLoadingProgress)
            
            
        }.frame(width: 300, height: 500, alignment: .center).onAppear(perform: sendEvent(TonalCreateEvents.Find("MSFT")))
    }
}
