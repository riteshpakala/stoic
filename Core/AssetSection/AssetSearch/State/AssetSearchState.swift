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
    let searchState: SearchState = .init()
    var securityData: [Security] = []
}

public class AssetSearchCenter: GraniteCenter<AssetSearchState> {
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
