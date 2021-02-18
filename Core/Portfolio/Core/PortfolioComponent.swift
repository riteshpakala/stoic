//
//  PortfolioComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct PortfolioComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<PortfolioCenter, PortfolioState> = .init()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                
                switch state.type {
                case .expanded, .preview:
                    portfolioHeader
                    PaddingVertical(Brand.Padding.xSmall)
                    portfolioStrategy
                    GraniteButtonComponent(
                        state: .init(.add,
                                     padding: .init(0,0,Brand.Padding.xSmall,0),
                                     action: {
                                       GraniteHaptic.light.invoke()
                                       set(\.stage, value: .adding)
                                     }))
                default:
                    EmptyView.init().hidden()
                }
                
                switch state.type {
                case .expanded, .holdings:
                    if state.type == .expanded {
                        PaddingVertical()
                    }
                    
                    HoldingsComponent(state: .init(context: .portfolio(.preview)))
                        .share(.init(dep(\.hosted)))
                default:
                    EmptyView.init().hidden()
                    
                }
                
            }
            
            if state.stage == .adding {
                VStack {
                    GraniteModal(content: {
                        HoldingsComponent(state: .init(context: .strategy))
                            .share(.init(dep(\.hosted,
                                             PortfolioCenter.route)))
                    }, onExitTap: {
                        set(\.stage, value: .none)
                    })
                }
            }
        }
    }
    
    var portfolioHeader: some View {
        VStack {
            HStack(spacing: 0) {
                GraniteText("\(command.center.username)",
                            .headline,
                            .bold,
                            .trailing,
                            style: .init(gradient: [Brand.Colors.black.opacity(0.75),
                                                    Brand.Colors.black.opacity(0.36)]))
                    .padding(.top, Brand.Padding.medium)
                    .padding(.bottom, Brand.Padding.medium)
            }
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            
            //User details
            VStack(spacing: Brand.Padding.medium) {
                
                GraniteText("age: \(command.center.age) days",
                            .headline,
                            .bold)
            }
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            .padding(.bottom, Brand.Padding.medium)
            
            
            HStack(spacing: 0) {
                GraniteText("trading day: \(Date.nextTradingDay.asString)",
                            .headline,
                            .bold,
                            .leading,
                            style: .init(gradient: [Brand.Colors.black.opacity(0.75),
                                                    Brand.Colors.black.opacity(0.36)]))
                    .padding(.top, Brand.Padding.medium)
                    .padding(.bottom, Brand.Padding.medium)
                
                //Sign out
                GraniteText("sign out",
                            Brand.Colors.redBurn,
                            .subheadline,
                            .bold)
                    .padding(.top, Brand.Padding.medium)
                    .padding(.bottom, Brand.Padding.medium)
                    .modifier(TapAndLongPressModifier.init(tapAction: sendEvent(MainEvents.Logout(), .contact, haptic: .light) ))
                
                
            }
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            
        }
        .frame(maxWidth: .infinity)
        .shadow(color: Color.black.opacity(0.75), radius: 1.0, x: 1.0, y: 1.0)
        .background(GradientView(direction: .topLeading)
                        .shadow(color: Color.black, radius: 8.0, x: 3.0, y: 3.0))
        .padding(.top, Brand.Padding.medium)
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
        .padding(.bottom, Brand.Padding.medium)
    }
    
    var portfolioStrategy: some View {
        StrategyComponent(state: inject(\.envDependency,
                                        target: \.strategiesPortfolio))
            .listen(to: command, .stop)
            .share(.init(dep(\.envDependency)))
            .showEmptyState
            .frame(maxHeight: .infinity)
    }
}
