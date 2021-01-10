//
//  AssetGridItemState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class AssetGridItemState: GraniteState {
    var security: Security {
        payload?.object as? Security ?? EmptySecurity()
    }
    
    var input: String = ""
    let assetGridType: AssetGridType
    public init(_ type: AssetGridType) {
        assetGridType = type
    }
    
    public required init() {
        self.assetGridType = .standard
    }
}

public class AssetGridItemCenter: GraniteCenter<AssetGridItemState> {
    
}

