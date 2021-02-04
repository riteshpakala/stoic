//
//  GraniteLoadingComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/26/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct GraniteLoadingComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<GraniteLoadingCenter, GraniteLoadingState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            
            HStack {
                Image("logo")
                    .resizable()
                    .frame(width: EnvironmentConfig.isIPhone ? 120 : 160,
                           height: EnvironmentConfig.isIPhone ? 120 : 160,
                           alignment: .center)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Brand.Colors.black)
    }
}
