//
//  PortfolioComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct PortfolioComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<PortfolioCenter, PortfolioState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            Rectangle()
                .frame(width: 240, height: 100, alignment: .center)
                .padding()
                .foregroundColor(.clear)
                .background(LinearGradient(gradient: Gradient(colors: [Brand.Colors.yellow, Brand.Colors.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(10)
        }
    }
}
