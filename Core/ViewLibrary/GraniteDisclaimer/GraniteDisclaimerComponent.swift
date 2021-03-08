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
                            
                        VStack(spacing: 0) {
                            if state.isLoader {
                                
                                ProgressView().scaleEffect(0.84)
                                    .frame(width: 48, height: 48)
                                    .background(Brand.Colors.black
                                    .opacity(0.57)
                                    .cornerRadius(8.0)
                                    .shadow(color: Color.black.opacity(0.57), radius: 4, x: 1, y: 2)
                                    .padding(.top, Brand.Padding.medium)
                                    .padding(.bottom, Brand.Padding.medium)
                                    .padding(.leading, Brand.Padding.medium)
                                    .padding(.trailing, Brand.Padding.medium))
                                
                            } else {
                                
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
                                    
                                if state.isActionable {
                                    HStack {
                                        if state.cancel != nil {
                                            GraniteButtonComponent(state: .init(state.leftButtonText,
                                                                                textColor: Brand.Colors.greyV2,
                                                                                colors: [Brand.Colors.black,
                                                                                         Brand.Colors.black.opacity(0.24)],
                                                                                action: state.cancel))
                                        }
                                        GraniteButtonComponent(state: .init(state.rightButtonText,
                                                                            textColor: Brand.Colors.black,
                                                                            colors: [Brand.Colors.marbleV2,
                                                                                     Brand.Colors.marble.opacity(0.24)],
                                                                            action: state.action))
                                    }
                                }
                            }
                        }
                    
                
                )
                .shadow(color: Color.black, radius: 6.0, x: 4.0, y: 3.0)
            
            
            
            Spacer()
        }
        .padding(.top, Brand.Padding.medium)
        .padding(.bottom, Brand.Padding.medium)
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
    }
}
