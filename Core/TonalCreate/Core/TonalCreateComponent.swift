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
    
    public func link() {
        command.link(\TonalState.sentimentProgress,
                     target:\.sentimentLoadingProgress)
    }
    
    public var body: some View {
        VStack {
            switch state.stage {
            case .find:
                TonalFindComponent().shareRelays(relays([StockRelay.self, CryptoRelay.self, ExperienceRelay.self])).listen(to: command)
            case .set:
                TonalSetComponent().payload(state.payload).listen(to: command)
            case .tune:
                TonalTuneComponent().payload(state.payload).listen(to: command)
            default:
                EmptyView.init()
            }
            
//            if (state.stage == .tune) {
//                Text("\(state.sentimentLoadingProgress)")
//                TonalTuneComponent().payload(state.payload).listen(to: command)
//            }
            
            
        }
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .center)
    }
}
