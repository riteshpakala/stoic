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
            switch state.config.kind {
            case .topVolume(let securityType),
                 .winners(let securityType),
                 .losers(let securityType):
                AssetSectionComponent(
                    state: .init(windowType: state.config.kind,
                                 securityType))
                    .share(.init(dep(\.hosted),
                                 relays(
                                    [StockRelay.self,
                                     CryptoRelay.self])))
            case .portfolio:
                PortfolioComponent()
                    .share(.init(dep(\.hosted)))
            case .search:
                AssetSearchComponent(state: depObject(\.envDependency,
                                                      target: \.search.state))
                    .share(.init(dep(\.hosted,
                                     WindowCenter.route)))
            case .securityDetail(let kind):
                SecurityDetailComponent(state: .init(kind))
            case .tonalCreate(let stage):
                TonalCreateComponent(state: .init(stage))
                    .share(.init(dep(\.hosted)))
            default:
                EmptyView.init()
            }
        }.frame(maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center)
    }
}
