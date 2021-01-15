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
    
    var context: WindowType
    
    var assetData: [Asset] {
        payload?.object as? [Asset] ?? []
    }
    let assetGridType: AssetGridType
    public init(_ type: AssetGridType,
                context: WindowType) {
        assetGridType = type
        self.context = context
    }
    
    public required init() {
        self.assetGridType = .standard
        self.context = .unassigned
    }
}

public class AssetGridCenter: GraniteCenter<AssetGridState> {
    
}
