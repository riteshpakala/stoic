//
//  GraniteButtonComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct GraniteButtonComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<GraniteButtonCenter, GraniteButtonState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            switch state.type {
            case .text(let text):
                BasicButton(text: text)
            case .image(let name):
                Image(name)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: state.size.width,
                           height: state.size.height,
                           alignment: .leading)
                    .background(
                        Passthrough {
                            if state.selected {
                                GradientView(colors: [Brand.Colors.marbleV2,
                                                      Brand.Colors.marble],
                                             cornerRadius: 6.0,
                                             direction: .topLeading).overlay (
                                                
                                        Brand.Colors.black
                                                        .opacity(0.36)
                                                        .cornerRadius(4.0)
                                                        .shadow(color: .black, radius: 4, x: 2, y: 2)
                                                        .padding(.top, 4)
                                                        .padding(.leading, 4)
                                                        .padding(.trailing, 4)
                                                        .padding(.bottom, 4)
                                        
                                    
                                    )
                                    .padding(.top, -8)
                                    .padding(.leading, -8)
                                    .padding(.trailing, -8)
                                    .padding(.bottom, -8)
                            }
                        }
                    )
            case .add:
                VStack(spacing: 0) {
                    PaddingVertical(Brand.Padding.xSmall)
                    Circle()
                        .foregroundColor(Brand.Colors.marble).overlay(
                        
                            GraniteText("+", Brand.Colors.black,
                                        .headline,
                                        .bold)
                                        .shadow(color: .black, radius: 6, x: 1, y: 1)
                        
                        
                        ).frame(width: 24, height: 24)
                        .padding(.top, Brand.Padding.medium)
                        .padding(.leading, Brand.Padding.small)
                        .padding(.bottom, Brand.Padding.medium)
                        .shadow(color: .black, radius: 3, x: 1, y: 1)
                }
            }
        }
        .padding(.top, state.padding.top)
        .padding(.leading, state.padding.leading)
        .padding(.trailing, state.padding.trailing)
        .padding(.bottom, state.padding.bottom)
    }
}
