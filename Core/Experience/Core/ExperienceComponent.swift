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
        .init(repeating: GridItem(.flexible()), count: maxWidth)
    }
    
    var maxWidth: Int {
        Array(state.activeWindows.map { $0.count }).max() ?? 0
    }
    
    var maxHeight: Int {
        state.activeWindows.count
    }
    
    var basicLayout: [GridItem] {
        [GridItem(.flexible())]
    }
    
    public var body: some View {
        
        VStack {
            //Max Windows Height
            
            // Re-arranged to have 3 lazy v grids under 1, to allow
            // for more customizable formations involving a single view
            // in a 3 col arrangement etc.
            //
            LazyVGrid(columns: layout, spacing: Brand.Padding.small) {
                ForEach(0..<maxHeight, id: \.self) { col in
                    VStack(spacing: Brand.Padding.small) {
                        ForEach(0..<maxWidth, id: \.self) { row in
                            if row < state.activeWindows.count,
                               col < state.activeWindows[row].count,
                               state.activeWindows[row][col].kind != .unassigned {
                                window(state.activeWindows[row][col]).id(UUID()).onTapGesture(perform: {
                                    
                                    print(state.activeWindows[row][col].detail)
                                })
                            }
                        }
                    }
                }
            }
            
//            LazyVGrid(columns: layout, spacing: Brand.Padding.small) {
//                ForEach(state.activeWindows, id: \.self) { row in
//                    ForEach(row, id: \.self) { config in
//                        window(config).id(UUID()).onTapGesture(perform: {
//                            print(config.detail)
//                        })
//                    }
//                }
//            }
            
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
            .shareRelays(relays)
            .background(Color.black)
    }
}

