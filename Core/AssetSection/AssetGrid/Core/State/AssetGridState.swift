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
    case radio
    case standard
    case standardStoics
    case model
}

extension WindowType {
    var assetGridType: AssetGridType {
        switch self {
        case .floor:
            return .add
        case .strategy:
            return .radio
        default:
            return .standard
        }
    }
}

public class AssetGridState: GraniteState {
    var context: WindowType
    
    var assetData: [Asset] {
        payload?.object as? [Asset] ?? []
    }
    let assetGridType: AssetGridType
    
    public init(_ type: AssetGridType,
                context: WindowType) {
        self.assetGridType = type
        self.context = context
    }
    
    public required init() {
        self.assetGridType = .standard
        self.context = .unassigned
    }
}

public class AssetGridCenter: GraniteCenter<AssetGridState> {
    
}
