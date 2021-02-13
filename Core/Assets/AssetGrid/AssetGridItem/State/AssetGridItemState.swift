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
        asset.asSecurity ?? ((payload?.object as? Security) ?? (asset.asModel?.latestSecurity ?? EmptySecurity()))
    }
    var model: TonalModel? {
        asset.asModel ?? ((payload?.object as? TonalModel))
    }
    
    var radioSelections: [String] = []
    var input: String = ""
    let assetGridType: AssetGridType
    public init(_ type: AssetGridType, radioSelections: [String] = []) {
        assetGridType = type
        self.radioSelections = radioSelections
    }
    
    public required init() {
        self.assetGridType = .standard
        self.radioSelections = []
    }
}

public class AssetGridItemCenter: GraniteCenter<AssetGridItemState> {
    
}

