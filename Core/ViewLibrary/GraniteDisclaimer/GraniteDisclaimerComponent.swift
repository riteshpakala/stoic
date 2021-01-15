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
                            
                        GraniteText(state.text, .subheadline, .bold)
                            .padding(.top, Brand.Padding.medium)
                            .padding(.bottom, Brand.Padding.medium)
                            .padding(.leading, Brand.Padding.large)
                            .padding(.trailing, Brand.Padding.large)
                            .background(Brand.Colors.black
                                            .opacity(0.36)
                                            .cornerRadius(8.0)
                                            .shadow(color: .black, radius: 4, x: 2, y: 2))
                    
                
                )
            
            Spacer()
        }
        .padding(.top, Brand.Padding.large)
        .padding(.bottom, Brand.Padding.large)
        .padding(.leading, Brand.Padding.large)
        .padding(.trailing, Brand.Padding.large)
    }
}
