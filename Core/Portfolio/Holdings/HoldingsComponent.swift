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
                    Spacer()
                    AssetSearchComponent(state: .init(.portfolio(.add)))
                        .listen(to: command, .stop)
                    Spacer()
                    
                    PaddingVertical(Brand.Padding.xSmall)
                    GraniteButtonComponent(state: .init("cancel",
                                                        action: {
                                                            
                                                            set(\.addToPortfolio, value: false)
                                                        }))
                }
            } else {
                VStack(spacing: 0) {
                    VStack(alignment: .leading) {
                        GraniteText("portfolio",
                                    .headline,
                                    .bold,
                                    .leading)
                            .padding(.leading, Brand.Padding.medium)
                            .padding(.trailing, Brand.Padding.medium)
                        
                        
                        AssetGridComponent(state: .init(state.context.assetGridTypeForHoldings,
                                                        context: state.context))
                            .listen(to: command, .stop)
                            .payload(retrievePayload(\.envDependency,
                                                     target: \.user.portfolio?.holdings.securities)).showEmptyState
                            
                    }
                    .padding(.top, Brand.Padding.large)
                    
                    GraniteButtonComponent(
                        state: .init(.add,
                                     padding: .init(0,0,Brand.Padding.xSmall,0),
                                     action: {
                                       GraniteHaptic.light.invoke()
                                       set(\.addToPortfolio, value: true)
                                     }))
                }
            }
        }
    }
}


