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
            VStack {
                
                switch state.type {
                case .expanded, .preview:
                    portfolioHeader
                    portfolioStrategy
                    GraniteButtonComponent(
                        state: .init(.add,
                                     padding:
                                        .init(0,
                                              0,
                                              Brand.Padding.xSmall,
                                              0))).onTapGesture {
                                                GraniteHaptic.light.invoke()
                                                set(\.stage, value: .adding)
                                            }
                default:
                    EmptyView.init().hidden()
                }
                
                switch state.type {
                case .expanded, .holdings:
                    if state.type == .expanded {
                        PaddingVertical()
                    }
                    
                    HoldingsComponent(state: inject(\.envDependency,
                                                    target: \.holdingsPortfolio))
                        .share(.init(dep(\.hosted)))
                default:
                    EmptyView.init().hidden()
                    
                }
                
            }
            
            if state.stage == .adding {
                VStack {
                    GraniteModal(content: {
                        HoldingsComponent(state: inject(\.envDependency,
                                                        target: \.holdingsStrategy))
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
                GraniteText("trading day: \(Date.nextTradingDay.asString)",
                            .headline,
                            .bold,
                            .center,
                            style: .init(gradient: [Brand.Colors.black.opacity(0.75),
                                                    Brand.Colors.black.opacity(0.36)]))
                    .padding(.top, Brand.Padding.medium)
                    .padding(.leading, Brand.Padding.medium)
                    .padding(.bottom, Brand.Padding.medium)
                
            }
            
            //User details
            HStack(spacing: Brand.Padding.medium) {
                GraniteText("username: \(command.center.username)",
                            .headline,
                            .bold,
                            .leading)
                
                GraniteText("account age: 12 days",
                            .headline,
                            .bold,
                            .trailing)
            }
            
            //Signals
            GraniteText("strategy signals",
                        .headline,
                        .bold,
                        .leading)
                .padding(.top, Brand.Padding.medium)
            
            VStack(spacing: Brand.Padding.xSmall) {
                GraniteText("buy: $MSFT",
                            .subheadline,
                            .bold,
                            .leading)
                
                GraniteText("sell: $MSFT",
                            .subheadline,
                            .bold,
                            .leading)
            }
            .padding(.top, Brand.Padding.small)
            
            //Strategy
            
            GraniteText("strategy overview",
                        .headline,
                        .bold,
                        .leading)
                .padding(.top, Brand.Padding.medium)
            
            HStack(spacing: Brand.Padding.medium) {
                GraniteText("winner: $MSFT - 4.12%",
                            .subheadline,
                            .bold,
                            .leading)
                
                GraniteText("loser: $MSFT - 4.12%",
                            .subheadline,
                            .bold,
                            .trailing)
            }
            .padding(.top, Brand.Padding.small)
            
            HStack(spacing: Brand.Padding.medium) {
                GraniteText("days left: 14 days",
                            .subheadline,
                            .bold,
                            .leading)
            }
            .padding(.bottom, Brand.Padding.small)
            
        }
        .padding(.top, Brand.Padding.large)
        .padding(.leading, Brand.Padding.large)
        .padding(.trailing, Brand.Padding.large)
        .padding(.bottom, Brand.Padding.large)
        .shadow(color: Color.black.opacity(0.57), radius: 4.0, x: 1.0, y: 2.0)
        .background(GradientView(direction: .topLeading)
                        .padding(.top, Brand.Padding.medium)
                        .padding(.leading, Brand.Padding.medium)
                        .padding(.trailing, Brand.Padding.medium)
                        .padding(.bottom, Brand.Padding.medium)
                        .shadow(color: Color.black, radius: 8.0, x: 3.0, y: 3.0))
                       
            
        
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
