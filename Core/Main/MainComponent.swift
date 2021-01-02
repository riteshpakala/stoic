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
    
    var experience: ExperienceComponent {
        ExperienceComponent()
    }
    
    
    public var body: some View {
//        AssetSectionComponent(state: .init(title: "Top Volume"))
//            .shareRelay(relay(CryptoRelay.self))
        
//        TonalCreateComponent().shareRelays(relays([CryptoRelay.self, StockRelay.self, TonalRelay.self]))
        
        if experience.state.isIPhone {
            VStack {
                ExperienceComponent(state: .init(.init(kind: .portfolio)))
                ControlBar(isIPhone: true, selectedFolder: _state.folder)
            }
        } else {
            HStack {
                ControlBar(isIPhone: false, selectedFolder: _state.folder)
                ExperienceComponent(state: .init(.init(kind: .portfolio)))
            }
        }
        
    }
}

struct ControlBar: View {
    var isIPhone: Bool
    @Binding var selectedFolder: String?

    var body: some View {
        if isIPhone {
            HStack {
                
                actions
                
            }.frame(minWidth: 100,
                    maxWidth: 120,
                    maxHeight: .infinity,
                    alignment: .center)
        } else {
            VStack {
                
                actions
                
            }.frame(minWidth: 100,
                    maxWidth: 120,
                    maxHeight: .infinity,
                    alignment: .center)
        }
    }
    
    var actions: some View {
        Passthrough {
            HStack {
                Text("Home")
            }
            HStack {
                Text("Home 2")
            }
            HStack {
                Text("Home 3")
            }
            HStack {
                Text("Home 4")
            }
        }
    }
}

struct Passthrough<Content>: View where Content: View {

    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
    }

}
