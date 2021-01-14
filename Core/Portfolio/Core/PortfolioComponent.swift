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
            Rectangle()
                .frame(height: 100, alignment: .center)
                .padding()
                .foregroundColor(.clear)
                .background(LinearGradient(gradient: Gradient(colors: [Brand.Colors.yellow, Brand.Colors.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(12)
                .shadow(color: Color.black, radius: 8.0, x: 4.0, y: 3.0).overlay (
                
                    Brand.Colors.black.opacity(0.36).overlay(
                        
                        
//                            Text("TEST").granite_innerShadow(
//                                Brand.Colors.white,
//                                radius: 1,
//                                offset: .init(x: 0.5, y: 0.5))
                        GraniteText("TEST")
                        .multilineTextAlignment(.center)
                        .font(Fonts.live(.subheadline, .bold))
                        
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
