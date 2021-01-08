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
    
    public var body: some View {
        VStack {
            switch state.stage {
            case .find:
                TonalFindComponent()
                    .shareRelays(
                        relays([StockRelay.self,
                                CryptoRelay.self]))
                    .listen(to: command)
                    .inject(dep(\.hosted), TonalSetCenter.route)
            case .set:
                TonalSetComponent()
                    .shareRelays(
                        relays([TonalRelay.self]))
                    .listen(to: command)
                    .inject(dep(\.hosted), TonalTuneCenter.route)
            case .tune:
                TonalTuneComponent()
                    .listen(to: command)
                    .shareRelays(
                        relays([TonalRelay.self]))
                    .inject(dep(\.hosted))
            case .compile:
                TonalCompileComponent()
                    .listen(to: command)
                    .inject(dep(\.hosted))
            default:
                EmptyView.init()
            }
        }
    }
}
