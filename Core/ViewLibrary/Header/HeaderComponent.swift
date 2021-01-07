//
//  HeaderComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct HeaderComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<HeaderCenter, HeaderState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            GraniteText(self.state.title,
                        .title,
                        .bold,
                        .leading)
        }.frame(maxWidth: .infinity,
                minHeight: 50,
                idealHeight: 50,
                maxHeight: 50).background(Color.black)
    }
}
