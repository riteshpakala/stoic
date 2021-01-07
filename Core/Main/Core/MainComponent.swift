//
//  MainComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct MainComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<MainCenter, MainState> = .init()
    
    public init() {}
    
    var controls: ControlBar {
        ControlBar(isIPhone: false, onRoute: { route in
            command.dependency(\RouterDependency.router.route, value: route)
        })
    }
    
    var environment: EnvironmentComponent {
        EnvironmentComponent(state: .init(depObject(\.routerDependency,
                                                    target: \.router.route)))
    }
    
    public var body: some View {
        
        VStack {
//        AssetSectionComponent(state: .init(title: "Top Volume"))
//            .shareRelay(relay(CryptoRelay.self))
        
//        TonalCreateComponent().shareRelays(relays([CryptoRelay.self, StockRelay.self, TonalRelay.self]))
        
        
        
//        if experience.state.isIPhone {
//            VStack {
//                ExperienceComponent(state: .init(.init(kind: .portfolio)))
//                ControlBar(isIPhone: true, selectedFolder: _state.folder)
//            }
//        } else {
            HStack {
                controls
                environment.inject(dep(\.hosted))
            }
//        }
        }
        .background(Color.black)
    }
}
