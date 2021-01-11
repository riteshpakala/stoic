//
//  TonalModelsComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalModelsComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalModelsCenter, TonalModelsState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            AssetGridComponent(state: .init(.add))
                .payload(.init(object: state.tones))
                .listen(to: command, .stop)
            
            VStack(spacing: 0) {
                Spacer()
                PaddingVertical(Brand.Padding.xSmall)
                GraniteButtonComponent(state: .init(command.center.createText)).onTapGesture {
//                    set(\.addToPortfolio, value: true)
                }
            }
        }.padding(.top, Brand.Padding.large)
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
    }
}
