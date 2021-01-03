//
//  TonalFindComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalFindComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalFindCenter, TonalFindState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {
            Spacer().frame(height: Brand.Padding.large)
            SearchComponent().shareRelays(relays([StockRelay.self, CryptoRelay.self]))
            AssetGridComponent()
                .listen(to: command)
                .payload(state.payload)
        }.background(Brand.Colors.black)
    }
}
