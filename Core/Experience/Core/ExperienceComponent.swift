//
//  ExperienceComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct ExperienceComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<ExperienceCenter, ExperienceState> = .init()
    
    public init() {}
    
    var layout: [GridItem] {
        .init(repeating: GridItem(.flexible()), count: Int(state.maxWindows.width))
    }
    
    public var body: some View {
        
        VStack {
            //Max Windows Height
            LazyVGrid(columns: layout, spacing: Brand.Padding.small) {
                ForEach(state.activeWindows, id: \.self) { row in
                    ForEach(row, id: \.self) { config in
                        window(config).id(UUID()).onTapGesture(perform: {
                            print(config.detail)
                        })
                    }
                }
            }
            
        }.frame(minWidth: command.center.environmentMinSize.width,
                maxWidth: .infinity,
                minHeight: command.center.environmentMinSize.height,
                maxHeight: .infinity,
                alignment: .center)
        .onAppear(perform: sendEvent(ExperienceEvents.Boot()))
    }
}

extension ExperienceComponent {
    func window(_ config: WindowConfig) -> some View {
        return WindowComponent(state: .init(config))
            .shareRelays(relays([CryptoRelay.self, StockRelay.self, TonalRelay.self]))
            .background(Brand.Colors.black)
    }
}

