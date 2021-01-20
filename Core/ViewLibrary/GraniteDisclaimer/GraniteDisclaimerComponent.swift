//
//  GraniteDisclaimerComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct GraniteDisclaimerComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<GraniteDisclaimerCenter, GraniteDisclaimerState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            Spacer()
            
            GradientView(colors: command.center.gradients,
                         direction: .topLeading)
                        .opacity(state.opacity).overlay (
                            
                        GraniteText("\n\(state.text)\n", .subheadline, .bold)
                            .padding(.top, Brand.Padding.medium)
                            .padding(.bottom, Brand.Padding.medium)
                            .padding(.leading, Brand.Padding.large)
                            .padding(.trailing, Brand.Padding.large)
                            .background(Brand.Colors.black
                                            .opacity(0.57)
                                            .cornerRadius(8.0)
                                            .shadow(color: Color.black.opacity(0.57), radius: 4, x: 1, y: 2)
                                            .padding(.top, Brand.Padding.medium)
                                            .padding(.bottom, Brand.Padding.medium)
                                            .padding(.leading, Brand.Padding.medium)
                                            .padding(.trailing, Brand.Padding.medium))
                    
                
                )
                .shadow(color: Color.black, radius: 6.0, x: 4.0, y: 3.0)
            
            Spacer()
        }
        .padding(.top, Brand.Padding.large)
        .padding(.bottom, Brand.Padding.large)
        .padding(.leading, Brand.Padding.large)
        .padding(.trailing, Brand.Padding.large)
    }
}
