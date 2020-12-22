//
//  Asset.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/21/20.
//

import Foundation

public enum AssetType {
    case security
    case model
}

public protocol Asset {
    var assetType: AssetType { get }
}
