//
//  AssetGridType.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/13/21.
//

import Foundation


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
        case .portfolio:
            return .add
        default:
            return .standard
        }
    }
    
    var assetGridTypeForHoldings: AssetGridType {
        switch self {
        case .strategy:
            return .radio
        default:
            return .standard
        }
    }
}
