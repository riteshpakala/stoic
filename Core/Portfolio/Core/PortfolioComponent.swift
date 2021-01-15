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
            case .expanded, .preview:
                portfolioHeader
                portfolioDescription
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
    }
    
    var portfolioHeader: some View {
        VStack {
            GradientView().overlay (
                
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
    
    var portfolioDescription: some View {
        VStack {
            Text("details")
        }
        .padding(.top, Brand.Padding.large)
        .padding(.bottom, Brand.Padding.large)
        .padding(.leading, Brand.Padding.large)
        .padding(.trailing, Brand.Padding.large)
        .frame(maxHeight: .infinity)
    }
}
