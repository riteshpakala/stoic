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
    var asset: Asset {
        payload?.object as? Asset ?? EmptySecurity()
    }
    var security: Security {
        asset.asSecurity ?? ((payload?.object as? Security) ?? EmptySecurity())
    }
    var model: TonalModel? {
        asset.asModel ?? ((payload?.object as? TonalModel))
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

