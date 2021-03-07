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
        let tuner = inject(\.detailDependency,
                               target: \.detail.slider)
        return tuner ?? .init()
    }
    
    public var body: some View {
        VStack(spacing: 0) {
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
                .padding(.trailing, Brand.Padding.xMedium)
                .padding(.top, Brand.Padding.medium9)
                
                VStack {
                    Spacer()
                    HStack {
                        GraniteText(command.center.security.title,
                                    .title3,
                                    .bold,
                                    style: .init(gradient: [Color.black.opacity(0.75),
                                                            Color.black.opacity(0.36)]))
                        
                        Spacer()
                        
                        switch state.kind {
                        case .expanded:
                            GraniteText("\(EnvironmentConfig.isIPhone ? "" : "last updated: ")\(command.center.security.date.asStringWithTime)",
                                        Brand.Colors.marble,
                                        .footnote,
                                        .regular)
                        default:
                            GraniteText("\(command.center.security.date.asStringWithTime)",
                                        Brand.Colors.marble,
                                        .footnote,
                                        .regular)
                        }
                        
                        
                        GraniteButtonComponent(state: .init(.image("refresh_icon"),
                                                            selected: true,
                                                            size: .init(16),
                                                            padding: .init(0,
                                                                           Brand.Padding.medium,
                                                                           Brand.Padding.xSmall,
                                                                           Brand.Padding.xSmall),
                                                            action: {
                                                                    GraniteHaptic.light.invoke()
                                                                    sendEvent(SecurityDetailEvents.Refresh())
                                                            }))
                    }
                }
                .padding(.leading, Brand.Padding.medium)
                .padding(.trailing, Brand.Padding.medium)
                .padding(.bottom, Brand.Padding.medium)
                
            }
            
            if case .expanded = state.kind {
                PaddingVertical()
                ZStack {
                    IndicatorDetailComponent(state: .init(state.quote))
                        
                    
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
                    
            }
        }
    }
}
