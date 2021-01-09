//
//  AssetSearchState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class AssetSearchState: GraniteState {
    let searchState: SearchState
    var securityData: [Security] = []
    let context: WindowType
    
    public init(_ context: WindowType) {
        self.context = context
        self.searchState = .init(context)
    }
    
    public required init() {
        self.context = .unassigned
        self.searchState = .init()
    }
}

public class AssetSearchCenter: GraniteCenter<AssetSearchState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            SearchAssetExpedition.Discovery(),
            AssetSelectedExpedition.Discovery()
        ]
    }
}
