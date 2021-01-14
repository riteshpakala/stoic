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
    
    public var body: some View {
        //DEV:
        
        ZStack {
            if !command.center.loaded {
                switch state.kind {
                case .floor:
                    Circle()
                        .foregroundColor(Brand.Colors.marble).overlay(
                        
                            GraniteText("+", Brand.Colors.black, .title3, .bold)
                        
                        
                        ).frame(width: 42, height: 42)
                case .expanded,
                     .preview:
                    
                    GraniteText("loading",
                                command.center.security.isGainer ? Brand.Colors.green : Brand.Colors.red,
                                .subheadline,
                                .regular,
                                .center)
                    
                }
            }
            GraphComponent(state: .init(state.quote)).frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
