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
            BasicButton(text: state.text)
        }
        .padding(.top, Brand.Padding.medium)
        .padding(.leading, Brand.Padding.large)
        .padding(.trailing, Brand.Padding.large)
        .padding(.bottom, Brand.Padding.medium)
    }
}
