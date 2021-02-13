//
//  FloorComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct FloorComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<FloorCenter, FloorState> = .init()
    
    public init() {}
    
    var layout: [GridItem] {
        .init(repeating: GridItem(.flexible()), count: maxWidth)
    }
    
    var maxWidth: Int {
        Array(state.activeSecurities.map { $0.count }).max() ?? 0
    }
    
    var maxHeight: Int {
        state.activeSecurities.count
    }
    
    func getSecurity(row: Int, col: Int) -> Security? {
        return state.activeSecurities[row][col]
    }
    
    func getQuote(row: Int, col: Int) -> Quote? {
        return state.activeQuotes[row][col]
    }
    
    public var body: some View {
        ZStack {
            
            if EnvironmentConfig.isIPhone {
                ScrollView {
                    VStack(spacing: Brand.Padding.small) {
                        generate.frame(minWidth: 0,
                                       maxWidth: .infinity,
                                       minHeight: command.center.environmentIPhoneSize.height,
                                       idealHeight: command.center.environmentIPhoneSize.height,
                                       maxHeight: command.center.environmentIPhoneSize.height,
                                       alignment: .center)
                    }
                    .background(Color.black)
                }
            } else {
                HStack(spacing: Brand.Padding.small) {
                    generate
                }
                .background(Color.black)
            }
            
            switch state.floorStage {
            case .adding(_):
                VStack {
                    GraniteModal(content: {
                        HoldingsComponent(state: .init(context: .floor))
                            .share(.init(dep(\.hosted)))
                    }, onExitTap: {
                        set(\.floorStage, value: .none, update: \EnvironmentDependency.floorStage)
                    })
                }
            default:
                EmptyView.init().hidden()
            }
        }
    }
    
    var generate: some View {
        //Max Windows Height
        ForEach(0..<maxHeight, id: \.self) { col in
            VStack(spacing: Brand.Padding.small) {
                ForEach(0..<maxWidth, id: \.self) { row in
                    if row < state.activeSecurities.count,
                       col < state.activeSecurities[row].count{
                        
                        if let security = getSecurity(row: row, col: col) {
                            SecurityDetailComponent(state: .init(.floor(.init(object: security)), quote: getQuote(row: row, col: col)))
                                .share(.init(dep(\.hosted))).background(Brand.Colors.black)
                        } else {
                            HStack {
                                Spacer()
                                GraniteButtonComponent(
                                    state: .init(.addNoSeperator,
                                                 action: {
                                                    set(\.floorStage, value: .adding(CGPoint.init(row, col)), update: \EnvironmentDependency.floorStage)
                                                 }))
                                Spacer()
                            }.frame(maxWidth: .infinity,
                                    maxHeight: .infinity).background(Brand.Colors.black)
                        }
                    }
                }
            }
        }
    }
}
