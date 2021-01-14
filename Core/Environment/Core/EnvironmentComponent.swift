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

public struct EnvironmentComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<EnvironmentCenter, EnvironmentState> = .init()
    
    public init() {}
    
    var layout: [GridItem] {
        .init(repeating: GridItem(.flexible()), count: command.center.maxWidth)
    }
    
    var controls: ControlBar {
        ControlBar(isIPhone: EnvironmentConfig.isIPhone,
                   currentRoute: command.center.routerDependency.router.route,
                   onRoute: { route in
            command.center.routerDependency.router.request(route)
        })
    }
    
    public var body: some View {
        if EnvironmentConfig.isIPhone {
            VStack(alignment: .center, spacing: Brand.Padding.small) {
                ScrollView {
                    //Max Windows Height
                    ForEach(0..<command.center.maxHeight, id: \.self) { col in
                        VStack(spacing: Brand.Padding.small) {
                            ForEach(0..<command.center.maxWidth, id: \.self) { row in
                                if row < state.activeWindowConfigs.count,
                                   col < state.activeWindowConfigs[row].count,
                                   state.activeWindowConfigs[row][col].kind != .unassigned {
                                    
                                    getWindow(row, col, state.activeWindowConfigs[row][col])
                                }
                            }
                        }
                    }
                }
                
                controls.opacity(state.activeWindowConfigs.isEmpty ? 0.0 : 1.0)
                
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: 1800,
                    alignment: .center)
        } else {
            HStack(spacing:  command.center.nonIPhoneHStackSpacing) {
                controls.opacity(state.activeWindowConfigs.isEmpty ? 0.0 : 1.0)
                Spacer()
                //Max Windows Height
                ForEach(0..<command.center.maxHeight, id: \.self) { col in
                    VStack(spacing: Brand.Padding.small) {
                        ForEach(0..<command.center.maxWidth, id: \.self) { row in
                            if row < state.activeWindowConfigs.count,
                               col < state.activeWindowConfigs[row].count,
                               state.activeWindowConfigs[row][col].kind != .unassigned {
                                
                                getWindow(row, col, state.activeWindowConfigs[row][col])
                            }
                        }
                    }
                }
                
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .center)
        }
    }
}

extension EnvironmentComponent {
    func getWindow(_ row: Int, _ col: Int, _ config: WindowConfig) -> some View {
        return window(config)
    }
}

extension EnvironmentComponent {
    func window(_ config: WindowConfig) -> some View {
       let window = createWindow(config)
                        .share(.init(dep(\.envDependency)))
                        .background(Brand.Colors.black)
                        .border(state.route.isDebug ? Brand.Colors.red : .clear,
                                width: state.route.isDebug ? 4.0 : 0.0)
        return window
    }
    
    func createWindow(_ config: WindowConfig) -> WindowComponent {
        return WindowComponent(state: .init(config))
    }
}
