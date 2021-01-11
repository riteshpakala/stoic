//
//  AssetAddComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct AssetAddComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<AssetAddCenter, AssetAddState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            Spacer()
            AssetSearchComponent(state: state.searchState.state)
                .share(.init(dep(\.hosted)))
            Spacer()
        }
    }
}
