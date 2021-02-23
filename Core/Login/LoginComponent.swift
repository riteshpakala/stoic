//
//  LoginComponent.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine
import AuthenticationServices

public struct LoginComponent: GraniteComponent {
    @Environment(\.openURL) var openURL
    
    @ObservedObject
    public var command: GraniteCommand<LoginCenter, LoginState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            ZStack {
                SpecialComponent()
                VStack {
                    Spacer()
                    
                    switch state.stage {
                    case .none:
                        start
                    case .experience:
                        experience
                    default:
                        if state.stage != .none {
                            GraniteText("< back", Brand.Colors.marble, .subheadline, .regular, .leading)
                                .modifier(TapAndLongPressModifier.init(tapAction: {
                                                                        
                                    set(\.stage, value: .none)
                                    set(\.success, value: false)
                                    set(\.error, value: nil)
                                    
                                }))
                                .padding(.top, Brand.Padding.medium)
                                .padding(.bottom, Brand.Padding.medium)
                                .padding(.leading, Brand.Padding.xSmall)
                        }
                        
                        if state.success {
                            VStack {
                                Spacer()
                                if state.stage == .apply {
                                    GraniteText("succesfully applied.",
                                                Brand.Colors.marble,
                                                .headline,
                                                .bold,
                                                .center)
                                }
                                Spacer()
                            }
                        } else {
                            auth
                        }
                    }
                }
                .frame(maxWidth: 300, maxHeight: .infinity)
                .padding(.bottom, Brand.Padding.large)
                .animation(.default)
            }
        }
        .background(Color.black)
        .frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center)
    }
    
    var start: some View {
        VStack(spacing: 0) {
            HStack(spacing: Brand.Padding.medium) {
                
                GraniteButtonComponent(state: .init("apply",
                                                    textColor: Brand.Colors.white,
                                                    colors: [Brand.Colors.yellow, Brand.Colors.purple],
                                                    padding: .init(Brand.Padding.medium,
                                                                   Brand.Padding.small,
                                                                   Brand.Padding.medium,
                                                                   Brand.Padding.small),
                                                   action: {
                                                    GraniteHaptic.light.invoke()
                                                       set(\.stage, value: .apply)
                                                   }))
                            
                
                GraniteButtonComponent(state: .init("sign in",
                                                    textColor: Brand.Colors.greyV2,
                                                    colors: [Brand.Colors.black,
                                                             Brand.Colors.marble.opacity(0.24)],
                                                    shadow: Brand.Colors.marble.opacity(0.57),
                                                    padding: .init(Brand.Padding.medium,
                                                                   Brand.Padding.small,
                                                                   Brand.Padding.medium,
                                                                   Brand.Padding.small),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        set(\.stage, value: .login)
                                                    }))
            }
        }
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
        .background(GradientView(colors: [Brand.Colors.black,
                                          Brand.Colors.black.opacity(0.0)],
                                          direction: .topLeading))
    }
    
    var auth: some View {
        VStack(spacing: 0) {
            
            HStack {
                
                TextField("email",
                          text: _state.email)
                    .background(Color.clear)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Fonts.live(.headline, .regular))
                    .padding(.leading, Brand.Padding.small)
                    .padding(.trailing, Brand.Padding.small)
                    .autocapitalization(.none)
            }
            .frame(height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            if state.stage != .apply {
                HStack {
                    
                    SecureField("password",
                              text: _state.password)
                        .background(Color.clear)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(Fonts.live(.headline, .regular))
                        .padding(.leading, Brand.Padding.small)
                        .padding(.trailing, Brand.Padding.small)
                        .autocapitalization(.none)
                }
                .frame(height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(.top, Brand.Padding.medium)
            }
                
            switch state.stage {
            case .signup:
                HStack {
                    
                    TextField("username",
                              text: _state.username)
                        .background(Color.clear)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(Fonts.live(.headline, .regular))
                        .padding(.leading, Brand.Padding.small)
                        .padding(.trailing, Brand.Padding.small)
                        .autocapitalization(.none)
                }
                .frame(height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(.top, Brand.Padding.medium)
                .padding(.bottom, Brand.Padding.medium)
                
                HStack {
                    
                    TextField("code",
                              text: _state.code)
                        .background(Color.clear)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(Fonts.live(.headline, .regular))
                        .padding(.leading, Brand.Padding.small)
                        .padding(.trailing, Brand.Padding.small)
                        .autocapitalization(.none)
                }
                .frame(height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                
                GraniteText("by signing up you agree to the terms & conditions",
                            Brand.Colors.marble,
                            .footnote,
                            .regular)
                    .padding(.top, Brand.Padding.medium)
                    .modifier(TapAndLongPressModifier(tapAction: {
                        //TODO: let's globalize this url
                        if let url = URL(string: "https://www.iubenda.com/terms-and-conditions/17232390") {
                            
                            openURL(url)
                        }
                    }))
            default:
                EmptyView().hidden()
            }
            
            if let errorText = state.error {
                HStack {
                    Spacer()
                    GraniteText(errorText,
                                Brand.Colors.redBurn,
                                .footnote,
                                .regular,
                                .leading)
                    Spacer()
                }
                .padding(.top, Brand.Padding.medium)
            }
            
            HStack(spacing: Brand.Padding.medium) {
                if state.stage == .apply {
                    GraniteButtonComponent(state: .init("learn",
                                                        textColor: Brand.Colors.greyV2,
                                                        colors: [Brand.Colors.black,
                                                                 Brand.Colors.marble.opacity(0.24)],
                                                        shadow: Brand.Colors.marble.opacity(0.57),
                                                        padding: .init(Brand.Padding.medium,
                                                                       Brand.Padding.small,
                                                                       Brand.Padding.medium,
                                                                       Brand.Padding.small),
                                                        action: {
                                                            GraniteHaptic.light.invoke()
                                                        }))
                } else {
                    GraniteButtonComponent(state: .init(state.stage == .login ? "sign up" : "sign in",
                                                        textColor: Brand.Colors.greyV2,
                                                        colors: [Brand.Colors.black,
                                                                 Brand.Colors.marble.opacity(0.24)],
                                                        shadow: Brand.Colors.marble.opacity(0.57),
                                                        padding: .init(Brand.Padding.medium,
                                                                       Brand.Padding.small,
                                                                       Brand.Padding.medium,
                                                                       Brand.Padding.small),
                                                        action: {
                                                            GraniteHaptic.light.invoke()
                                                            set(\.stage, value: state.stage == .login ? .signup : .login)
                                                        }))
                }
                
                GraniteButtonComponent(state: .init("continue",
                                                    textColor: Brand.Colors.white,
                                                    colors: [Brand.Colors.yellow, Brand.Colors.purple],
                                                    padding: .init(Brand.Padding.medium,
                                                                   Brand.Padding.small,
                                                                   Brand.Padding.medium,
                                                                   Brand.Padding.small),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        sendEvent(LoginEvents.Auth())
                                                    }))
            }
            .padding(.top, Brand.Padding.medium)
        }
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
        .background(GradientView(colors: [Brand.Colors.black,
                                          Brand.Colors.black.opacity(0.0)],
                                          direction: .topLeading))
    }
    
    var experience: some View {
        VStack {}
    }
}
