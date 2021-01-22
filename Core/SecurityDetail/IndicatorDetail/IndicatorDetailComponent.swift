//
//  IndicatorDetailComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/21/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct IndicatorDetailComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<IndicatorDetailCenter, IndicatorDetailState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            
            ZStack {
                GraphPage(someModel: command.center.plotData.percentK).opacity(0.75)
                
                GraphPage(someModel: command.center.plotData.percentD)
            }
            
        }.frame(maxWidth: .infinity,
                maxHeight: 200)
        .padding(.bottom, Brand.Padding.large)
    }
}
