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
            Text("\(command.center.dependency.hosted.identifier)")
            switch state.config.kind {
            case .topVolume(let securityType),
                 .winners(let securityType),
                 .losers(let securityType):
                AssetSectionComponent(
                    state: .init(windowType: state.config.kind,
                                 securityType))
                    .shareRelays(relays([CryptoRelay.self, StockRelay.self]))
            case .portfolio:
                PortfolioComponent()
            case .search:
                SearchComponent()
                
            case .modelCreate(let stage):
                TonalCreateComponent(state: .init(stage))
                    .shareRelays(relays)
                    .inject(dep(\.hosted))
            default:
                EmptyView.init()
            }
            
                        
        }.frame(
            idealWidth: state.config.style.idealWidth,
            maxWidth: .infinity,
            idealHeight: state.config.style.idealHeight,
            maxHeight: .infinity,
            alignment: .center)
    }
}
