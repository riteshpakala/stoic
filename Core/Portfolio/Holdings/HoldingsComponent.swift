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
            GeometryReader { geometry in
                GradientView(colors: [Brand.Colors.marbleV2,
                                      Brand.Colors.marble],
                             cornerRadius: 0.0,
                             direction: .top)
                            .shadow(color: Color.black,
                                    radius: 8.0,
                                    x: 4.0,
                                    y: 3.0)
                            .offset(x: 0,
                                    y: (geometry.size.height*(1.0 - (state.syncProgress.isNaN ? 0.0 : state.syncProgress.asCGFloat))))
                            .animation(.default)
            }
            
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
                        HStack(alignment: .center) {
                            GraniteText("portfolio",
                                        .headline,
                                        .bold)
                            
                            Spacer()
                            
                            GraniteText(state.statusLabel,
                                        Brand.Colors.marble,
                                        .subheadline,
                                        .regular)
                            
                            GraniteButtonComponent(state: .init(.image("refresh_icon"),
                                                                colors: [Brand.Colors.marbleV2,
                                                                         Brand.Colors.marble],
                                                                selected: true,
                                                                size: .init(16),
                                                                padding: .init(0,
                                                                               Brand.Padding.medium9,
                                                                               0,
                                                                               Brand.Padding.medium9),
                                                                action: {
                                                                    GraniteHaptic.light.invoke()
                                                                    sendEvent(HoldingsEvents.Update())
                                                                }))
                        }
                        .padding(.leading, Brand.Padding.medium)
                        .padding(.trailing, Brand.Padding.medium)
                        
                        
                        AssetGridComponent(state: .init(state.context.assetGridTypeForHoldings,
                                                        context: state.context))
                            .listen(to: command, .stop)
                            .payload(retrievePayload(\.envDependency2,
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
            
            if state.stage == .updating {
                GraniteDisclaimerComponent(state:
                                            .init("please wait, * stoic is\nupdating your portfolio\nwith the latest data.", opacity: 0.57))
            }
            
        }.clipped()
    }
}


