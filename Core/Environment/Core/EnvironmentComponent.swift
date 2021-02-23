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
    
    public var body: some View {
        ZStack {
            
            GraniteLoadingComponent()
            
            if EnvironmentConfig.isIPhone {
                GeometryReader { proxy in
                    VStack(alignment: .center,
                           spacing: Brand.Padding.small) {
                        ScrollView(showsIndicators: false) {
                            //Max Windows Height
                            ForEach(0..<command.center.maxWidth, id: \.self) { col in
                                VStack(spacing: 0) {
                                
                                    ForEach(0..<command.center.maxHeight, id: \.self) { row in
                                        if row < state.activeWindowConfigs.count,
                                           col < state.activeWindowConfigs[row].count,
                                           state.activeWindowConfigs[row][col].kind != .unassigned {
                                            
                                            getWindow(row,
                                                      col,
                                                      state.activeWindowConfigs[row][col])
                                            
                                            if  ((row + 1) * (col + 1)) < command.center.totalWindows {
                                                PaddingVertical(Brand.Padding.small)
                                            }
                                        }
                                    }
                                }.frame(minWidth: 0,
                                        maxWidth: .infinity,
                                        minHeight: command.center.environmentIPhoneSize.height,
                                        idealHeight: command.center.environmentIPhoneSize.height,
                                        maxHeight: command.center.environmentIPhoneSize.height,
                                        alignment: .center)
                            }
                        }
                        .background(Brand.Colors.black)
                    }.frame(minWidth: 0,
                            maxWidth: .infinity,
                            minHeight: 0,
                            maxHeight: .infinity,
                            alignment: .center)
                    .onAppear(perform: {
                        if state.localFrame == nil {
                            set(\.localFrame, value: proxy.localFrame)
                        }
                    })
                }
            } else {
                HStack(spacing:  command.center.nonIPhoneHStackSpacing) {
                    //Max Windows Height
                    ForEach(0..<command.center.maxWidth, id: \.self) { col in
                        VStack(spacing: Brand.Padding.small) {
                            ForEach(0..<command.center.maxHeight, id: \.self) { row in
                                if row < state.activeWindowConfigs.count,
                                   col < state.activeWindowConfigs[row].count,
                                   state.activeWindowConfigs[row][col].kind != .unassigned {
                                    
                                    getWindow(row, col, state.activeWindowConfigs[row][col])
                                }
                            }
                        }
                    }
                    
                }.background(Color.black)
                 .frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .center)
            }
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
                        .listen(to: command)
                        .background(Brand.Colors.black)
                        .border(state.route.isDebug ? Brand.Colors.red : .clear,
                                width: state.route.isDebug ? 4.0 : 0.0)
        
        
        return window
    }
    
    func createWindow(_ config: WindowConfig) -> WindowComponent {
        return WindowComponent(state: .init(config)).attach(to: command)
    }
}
