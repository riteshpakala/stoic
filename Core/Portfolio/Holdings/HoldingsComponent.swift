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
        VStack {
            GraniteText("portfolio",
                        .subheadline,
                        .regular,
                        .leading)
            
            VStack {
                Spacer()
                BasicButton(text: "create")
                Spacer()
            }
        }.padding(.top, Brand.Padding.large)
        .padding(.leading, Brand.Padding.large)
        .padding(.trailing, Brand.Padding.large)
    }
}
