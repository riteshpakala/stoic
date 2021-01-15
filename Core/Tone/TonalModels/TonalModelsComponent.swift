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
            VStack(alignment: .leading) {
                GraniteText("your models",
                            .headline,
                            .bold,
                            .leading)
                
                
                AssetGridComponent(state: .init(.standard, context: .tonalBrowser(.empty)))
                    .payload(.init(object: state.tones))
                    .listen(to: command, .stop).showEmptyState
                    
            }.padding(.top, Brand.Padding.large)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            
            Spacer()
            VStack(spacing: 0) {
                PaddingVertical(Brand.Padding.xSmall)
                GraniteButtonComponent(state: .init(command.center.createText)).onTapGesture {
//                    set(\.addToPortfolio, value: true)
                }
            }
        }
    }
}
