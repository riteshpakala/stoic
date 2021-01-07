//
//  AssetGridComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct AssetGridComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<AssetGridCenter, AssetGridState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            AssetGridItemContainerComponent()
                .listen(to: command)
                .payload(state.payload)
                .frame(
//                     minWidth: 300 + Brand.Padding.large,
//                       idealWidth: 414 + Brand.Padding.large,
                    maxWidth: .infinity,//420 + Brand.Padding.large,
//                       minHeight: 48 * 5,
//                       idealHeight: 50 * 5,
                    maxHeight: .infinity,//75 * 5,
                    alignment: .leading)
        }
    }
}
