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
                AssetAddComponent(state: state.assetAddState)
                    .share(.init(dep(\.hosted)))
                BasicButton(text: "cancel").onTapGesture {
                    set(\.addToPortfolio, value: false)
                }
            } else {
                VStack {
                    GraniteText("portfolio",
                                .subheadline,
                                .regular,
                                .leading)
                    VStack(alignment: .leading, spacing: Brand.Padding.medium) {
                        AssetGridComponent(state: .init(state.context == .floor ? .add : .standard))
                            .listen(to: command)
                            .payload(retrievePayload(\.envDependency,
                                                     target: \.user.portfolio?.holdings.securities))
                            
                    }
                    VStack {
                        Spacer()
                        BasicButton(text: "create").onTapGesture {
                            set(\.addToPortfolio, value: true)
                        }
                        Spacer()
                    }
                }.padding(.top, Brand.Padding.large)
                .padding(.leading, Brand.Padding.large)
                .padding(.trailing, Brand.Padding.large)
            }
        }
    }
}
