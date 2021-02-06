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
        switch state.stage {
        case .find(let payload):
            TonalFindComponent()
                .listen(to: command, .stop)
                .payload(payload)
                .share(.init(dep(\.hosted)))
        case .set:
            TonalSetComponent(state: inject(\.envDependency,
                                            target: \.tone.set.state))
                .listen(to: command, .stop)
                .share(.init(dep(\.hosted))).showEmptyState
        case .tune:
            TonalTuneComponent()
                .listen(to: command, .stop)
                .share(.init(dep(\.hosted))).showEmptyState
        case .compile:
            TonalCompileComponent()
                .listen(to: command, .stop)
                .share(.init(dep(\.hosted))).showEmptyState
        default:
            EmptyView.init().hidden()
        }
    }
}
