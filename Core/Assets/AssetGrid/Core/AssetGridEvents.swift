//
//  AssetGridEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct AssetGridEvents {
    public struct UpdateSecurities: GraniteEvent {
        
    }
    public struct AssetTapped: GraniteEvent {
        public let asset: Asset
        public init(_ asset: Asset) {
            self.asset = asset
        }
        
        public var behavior: GraniteEventBehavior {
            .quiet
        }
    }
    public struct AssetsSelected: GraniteEvent {
        public let assetIDs: [String]
        public init(_ assetIDs: [String]) {
            self.assetIDs = assetIDs
        }
    }
    public struct SecurityTapped: GraniteEvent {
        public let security: Security
        public init(_ security: Security) {
            self.security = security
        }
    }
}
