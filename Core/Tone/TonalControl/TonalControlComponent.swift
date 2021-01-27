//
//  TonalControlComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/25/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalControlComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalControlCenter, TonalControlState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            
            HStack {
                SentimentSliderComponent(state: state.tuner)
                    .listen(to: command)
                    .frame(width: 144)
                
                VStack(spacing: Brand.Padding.xSmall) {
                    GraniteText("high: $\(state.currentPrediction.high.display)",
                                .title3,
                                .bold,
                                .leading)
                        .shadow(color: .black,
                                radius: 2, x: 2, y: 2)
                    
                    GraniteText("close: $\(state.currentPrediction.close.display)",
                                .title3,
                                .bold,
                                .leading)
                        .shadow(color: .black,
                                radius: 2, x: 2, y: 2)
                    
                    GraniteText("low: $\(state.currentPrediction.low.display)",
                                .title3,
                                .bold,
                                .leading)
                        .shadow(color: .black,
                                radius: 2, x: 2, y: 2)
                    
                    GraniteText("volume: $\(state.currentPrediction.volume.display)",
                                .headline,
                                .bold,
                                .leading)
                        .shadow(color: .black,
                                radius: 2, x: 2, y: 2)
                }
                .frame(height: 144)
                .padding(.leading, Brand.Padding.medium)
                .background(Brand.Colors.purple
                                .opacity(0.75)
                                .cornerRadius(24.0)
                                .shadow(color: .black, radius: 3, x: 1, y: 2))
                .shadow(color: .black, radius: 4, x: 1, y: 2)
            }
            .padding(.top, Brand.Padding.medium)
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
           
            GraniteText(state.tuner.sentiment.asString,
                        Brand.Colors.yellow,
                        .subheadline,
                        .bold)
                        .padding(.top,
                                 Brand.Padding.medium)
                        .padding(.bottom, Brand.Padding.medium)
                        .shadow(color: .black,
                                radius: 3, x: 1, y: 2)
            
        }
    }
}
