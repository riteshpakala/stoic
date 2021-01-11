//
//  AssetGridState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum AssetGridType {
    case add
    case standard
    case standardStoics
    case model
}

public class AssetGridState: GraniteState {
    var assetData: [Asset] {
        payload?.object as? [Asset] ?? []
    }
    let assetGridType: AssetGridType
    public init(_ type: AssetGridType) {
        assetGridType = type
    }
    
    public required init() {
        self.assetGridType = .standard
    }
}

public class AssetGridCenter: GraniteCenter<AssetGridState> {
    
}
