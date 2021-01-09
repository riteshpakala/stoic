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
            AssetSearchComponent(state: depObject(\.envDependency,
                                                  target: \.searchAdd.state))
                .share(.init(dep(\.hosted),
                             relays(
                                [StockRelay.self,
                                 CryptoRelay.self])))
            Spacer()
        }
        .padding(.top, Brand.Padding.large)
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
    }
}
