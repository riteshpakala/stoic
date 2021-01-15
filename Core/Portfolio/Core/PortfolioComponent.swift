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
        VStack {
            
            switch state.type {
            case .expanded:
                portfolioHeader
            default:
                EmptyView.init().hidden()
            }
            
            PaddingVertical()
            
            HoldingsComponent(state: inject(\.envDependency,
                                            target: \.holdingsPortfolio))
                .share(.init(dep(\.hosted)))
        }
    }
    
    var portfolioHeader: some View {
        ZStack {
            GradientView().overlay (
                
                    Brand.Colors.black.opacity(0.36).overlay(
                        GraniteText("TEST", .subheadline, .bold)
                        
                    )
                    .cornerRadius(8.0)
                    .frame(width: 80, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .shadow(color: .black, radius: 4, x: 2, y: 2)
                
                )
            
            Spacer()
        }
        .padding(.top, Brand.Padding.large)
        .padding(.bottom, Brand.Padding.large)
        .padding(.leading, Brand.Padding.large)
        .padding(.trailing, Brand.Padding.large)
    }
}
