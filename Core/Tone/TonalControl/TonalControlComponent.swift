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
//        VStack {
            
//            HStack {
//                SentimentSliderComponent(state: state.tuner)
//                    .listen(to: command)
//                    .frame(width: 144)
//                    .padding(.top, Brand.Padding.medium)
                
                VStack {
                    ZStack(alignment: .top) {
                        GraniteText("high", .footnote, .regular, .trailing)
                            .padding(.top, Brand.Padding.small)
                            .padding(.trailing, Brand.Padding.small)
                        GraphPage(someModel: command.center.plotData.high)
                    }
                    ZStack(alignment: .top) {
                        GraniteText("low", .footnote, .regular, .trailing)
                            .padding(.top, Brand.Padding.small)
                            .padding(.trailing, Brand.Padding.small)
                        GraphPage(someModel: command.center.plotData.low)
                    }
                }
                .frame(height: 144)
                .padding(.top, Brand.Padding.small)
//                .padding(.leading, Brand.Padding.small)
//            }
//            .padding(.leading, Brand.Padding.medium)
//            .padding(.trailing, Brand.Padding.medium)
            
//        }
        
        ZStack {
            
            GraniteText("* stoic",
                        .headline,
                        .bold,
                        .leading,
                        style: .init(gradient: [Color.black.opacity(0.75),
                                                Color.black.opacity(0.36)]))
                        .padding(.bottom, Brand.Padding.xSmall)
            
            GraniteText(state.tuner.sentiment.asString,
                        Brand.Colors.yellow,
                        .subheadline,
                        .bold,
                        .trailing)
                        .shadow(color: .black,
                                radius: 3, x: 1, y: 2)
//            GraniteText("",
//                        Brand.Colors.purple,
//                        .subheadline,
//                        .regular,
//                        .trailing)
//                        .shadow(color: .black,
//                                radius: 3, x: 1, y: 2)
        }
        .padding(.top, Brand.Padding.medium)
        .padding(.bottom, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
        .padding(.leading, Brand.Padding.medium)
    }
}
