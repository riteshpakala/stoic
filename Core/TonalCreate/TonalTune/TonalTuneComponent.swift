//
//  TonalTuneComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalTuneComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalTuneCenter, TonalTuneState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            Brand.Colors.black.overlay(
                VStack {
                    if state.tone.sentiment == nil {
                        Text("loading...").granite_innerShadow(
                            Brand.Colors.white,
                            radius: 3,
                            offset: .init(x: 2, y: 2))
                            .multilineTextAlignment(.center)
                            .font(Fonts.live(.subheadline, .regular))
                    } else {
                        Text(state.tonalSentiment.stats)
                            .granite_innerShadow(
                            Brand.Colors.white,
                            radius: 3,
                            offset: .init(x: 2, y: 2))
                            .multilineTextAlignment(.center)
                            .font(Fonts.live(.subheadline, .regular))
                    }
                }
            )
            .frame(width: 120, height: 75, alignment: .center)
            .cornerRadius(8)
            
            
            SentimentSliderComponent()
        }.padding(.leading, Brand.Padding.large).padding(.trailing, Brand.Padding.large)
    }
}
