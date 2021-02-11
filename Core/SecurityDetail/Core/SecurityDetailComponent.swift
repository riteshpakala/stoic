//
//  SecurityDetailComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct SecurityDetailComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<SecurityDetailCenter, SecurityDetailState> = .init()
    
    public init() {}
    
    var tunerState: SentimentSliderState {
        let tuner = inject(\.envDependency,
                               target: \.detail.slider)
        return tuner ?? .init()
    }
    
    public var body: some View {
        //DEV:
        
        VStack {
            ZStack {
                if !command.center.loadedQuote {
                    switch state.kind {
                    case .floor:
                        Circle()
                            .foregroundColor(Brand.Colors.marble).overlay(
                            
                                GraniteText("+",
                                            Brand.Colors.black,
                                            .headline,
                                            .bold)
                                            .shadow(color: .black, radius: 3, x: 1, y: 1)
                            
                            
                            ).frame(width: 24, height: 24)
                    case .expanded,
                         .preview:
                        
                        GraniteText("loading",
                                    command.center.security.statusColor,
                                    .subheadline,
                                    .regular,
                                    .center)
                        
                    }
                }
                
                GraphComponent(state: .init(state.quote))
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity)
                
                
                VStack {
                    GraniteText(command.center.security.symbol,
                                .title3,
                                .bold,
                                .trailing,
                                style: .init(gradient: [Color.black.opacity(0.75),
                                                        Color.black.opacity(0.36)]))
                    Spacer()
                }
                .padding(.leading, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium)
                .padding(.top, Brand.Padding.medium)
                
                VStack {
                    Spacer()
                    GraniteText(command.center.security.title,
                                .title3,
                                .bold,
                                .leading,
                                style: .init(gradient: [Color.black.opacity(0.75),
                                                        Color.black.opacity(0.36)]))
                }
                .padding(.leading, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium)
                .padding(.bottom, Brand.Padding.medium)
                
            }
            
            if case .expanded = state.kind,
               command.center.loaded {
                PaddingVertical()
                ZStack {
                    IndicatorDetailComponent(state: .init(state.quote))
                        .share(.init(dep(\.hosted)))
                    
                    VStack {
                        Spacer()
                        GraniteText("stochastics",
                                    .headline,
                                    .bold,
                                    .leading,
                                    style: .init(gradient: [Color.black.opacity(0.75),
                                                            Color.black.opacity(0.36)]))
                    }
                    .padding(.leading, Brand.Padding.medium)
                    .padding(.trailing, Brand.Padding.medium)
                    .padding(.bottom, Brand.Padding.medium)
                }.frame(maxWidth: .infinity,
                        maxHeight: 120)
            }
            
            if state.model != nil {
                
                PaddingVertical()
                
                TonalControlComponent(state: .init(tunerState, model: state.model))
                    .share(.init(dep(\.hosted)))
            }
        }
    }
}
