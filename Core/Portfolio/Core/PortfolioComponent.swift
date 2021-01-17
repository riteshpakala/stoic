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
                    PaddingVertical(Brand.Padding.xSmall)
                    portfolioStrategy
                    GraniteButtonComponent(
                        state: .init(.add,
                                     padding:
                                        .init(Brand.Padding.medium,
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
            GradientView(direction: .topLeading).overlay (
                
                    Brand.Colors.black.opacity(0.36).overlay(
                        GraniteText("TEST", .subheadline, .bold)
                        
                    )
                    .cornerRadius(8.0)
                    .frame(width: 80, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .shadow(color: .black, radius: 4, x: 2, y: 2)
                
                )
        }
        .padding(.top, Brand.Padding.large)
        .padding(.bottom, Brand.Padding.large)
        .padding(.leading, Brand.Padding.large)
        .padding(.trailing, Brand.Padding.large)
        .frame(height: 200)
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
