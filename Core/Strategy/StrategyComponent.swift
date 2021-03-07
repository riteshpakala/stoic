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
//                GraniteButtonComponent(
//                    state: .init(.addNoSeperator,
//                                 padding: .init(0,0,0,0),
//                                 action: {
//                                   GraniteHaptic.light.invoke()
//                                   set(\.stage, value: .adding)
//                                 }))
//                    .background(Brand.Colors.black)
                Spacer()
            }
        }.padding(.bottom, Brand.Padding.xSmall)
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
