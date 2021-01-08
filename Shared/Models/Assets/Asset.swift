//
//  Asset.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/21/20.
//

import Foundation
import GraniteUI

public enum AssetType {
    case security
    case model
    case sentiment
}

public protocol Asset: ID {
    var assetType: AssetType { get }
}
