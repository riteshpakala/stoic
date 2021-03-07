//
//  StrategyComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct StrategyComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<StrategyCenter, StrategyState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            switch state.type {
            case .preview:
                StrategyPreview(command: command)
                
                PaddingVertical(Brand.Padding.xSmall)
                HStack(alignment: .center) {
                    Spacer()
                    GraniteButtonComponent(
                        state: .init("detail",
                                    padding: .init(Brand.Padding.medium,
                                                   0,
                                                   Brand.Padding.medium,
                                                   0),
                                    action: route(Route.strategyDetail)))
                    Spacer()
                    GraniteButtonComponent(
                        state: .init("+",
                                    padding: .init(Brand.Padding.medium,
                                                   0,
                                                   Brand.Padding.medium,
                                                   0),
                                    action: {
                                        sendEvent(TonalCompileEvents.Compile(), haptic: .light)
                                    }))
                    Spacer()
                }
            case .expanded:
                HStack(alignment: .center, spacing: Brand.Padding.medium) {
                    GraniteButtonComponent(
                        state: .init("export",
                                    padding: .init(0,
                                                   0,
                                                   0,
                                                   0),
                                    action: {}))
                    
                    Spacer()
                    
                        
                    Image("logo_small")
                        .resizable()
                        .frame(width: 42,
                               height: 42,
                               alignment: .center)
                }
                .padding(.top, Brand.Padding.xSmall)
                .padding(.leading, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium9)
                
                StrategyExpanded(command: command)
                    .padding(.top, Brand.Padding.large)
                
                GraniteButtonComponent(
                    state: .init(.add,
                                 padding: .init(0,0,0,0),
                                 action: {
                                   GraniteHaptic.light.invoke()
                                   set(\.stage, value: .adding)
                                 }))
                    .background(Brand.Colors.black)
            default:
                EmptyView().hidden()
                
            }
        }
        .padding(.top, Brand.Padding.medium9)
        .padding(.bottom, Brand.Padding.xSmall)
    }
}

//MARK: -- Empty State Settings
extension StrategyComponent {
    
    public var emptyText: String {
        "create strategies from your \ncurrently held stocks or crypto\n\n* stoic models will then\nguide your investments"
    }
    
    public var isDependancyEmpty: Bool {
        command.center.strategies.isEmpty
    }
    
    public var emptyPayload: GranitePayload? {
        return .init(object: [Brand.Colors.purple, Brand.Colors.yellow])
    }
}
