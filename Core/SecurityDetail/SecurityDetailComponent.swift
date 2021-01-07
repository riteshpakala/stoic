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
        GraphComponent().frame(maxWidth: .infinity, maxHeight: 500)
    }
}
