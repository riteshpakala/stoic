//
//  HoldingsComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct HoldingsComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<HoldingsCenter, HoldingsState> = .init()
    
    public init() {}
   
    public var body: some View {
        ZStack {
            if state.addToPortfolio {
                VStack(spacing: 0) {
                    AssetAddComponent(state: state.assetAddState)
                        .share(.init(dep(\.hosted)))
                    Spacer()
                    PaddingVertical(Brand.Padding.xSmall)
                    GraniteButtonComponent(state: .init("cancel")).onTapGesture {
                        set(\.addToPortfolio, value: false)
                    }
                }
            } else {
                VStack {
                    VStack(alignment: .leading) {
                        GraniteText("portfolio",
                                    .headline,
                                    .bold,
                                    .leading)
                        
                        AssetGridComponent(state: .init(state.context == .floor ? .add : .standard,
                                                        context: state.context))
                            .listen(to: command, .stop)
                            .payload(retrievePayload(\.envDependency,
                                                     target: \.user.portfolio?.holdings.securities)).showEmptyState
                            
                    }
                    .padding(.top, Brand.Padding.large)
                    .padding(.leading, Brand.Padding.medium)
                    .padding(.trailing, Brand.Padding.medium)
                    
                    if state.type == .add {
                        Spacer()
                        VStack(spacing: 0) {
                            PaddingVertical(Brand.Padding.xSmall)
                            Circle()
                                .foregroundColor(Brand.Colors.marble).overlay(
                                
                                    GraniteText("+", Brand.Colors.black,
                                                .headline,
                                                .bold)
                                                .shadow(color: .black, radius: 3, x: 1, y: 1)
                                
                                
                                ).frame(width: 24, height: 24)
                                .padding(.top, Brand.Padding.medium)
                                .padding(.leading, Brand.Padding.small)
                                .padding(.bottom, Brand.Padding.medium)
                                .onTapGesture {
                                    GraniteHaptic.light.invoke()
                                    set(\.addToPortfolio, value: true)
                            }
                        }
                    }
                }
            }
        }
    }
}
