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
    
    public init() {
        
        print("{TEST} --- hold init \(addToPortfolio)")
    }
    
    @State var addToPortfolio: Bool = false
    
    public var body: some View {
        ZStack {
            if addToPortfolio {
                AssetAddComponent()
                    .share(.init(dep(\.hosted)))
                BasicButton(text: "cancel").onTapGesture {
                    $addToPortfolio.wrappedValue = !addToPortfolio
                }
            } else {
                VStack {
                    GraniteText("portfolio",
                                .subheadline,
                                .regular,
                                .leading)
                    
                    VStack {
                        Spacer()
                        BasicButton(text: "create").onTapGesture {
                            $addToPortfolio.wrappedValue = !addToPortfolio
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
