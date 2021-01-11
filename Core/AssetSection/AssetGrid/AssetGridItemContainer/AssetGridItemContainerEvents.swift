//
//  AssetGridItemContainerEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct AssetGridItemContainerEvents {
    public struct UpdateSecurities: GraniteEvent {
        
    }
    public struct AssetTapped: GraniteEvent {
        public let asset: Asset
        public init(_ asset: Asset) {
            self.asset = asset
        }
    }
    public struct SecurityTapped: GraniteEvent {
        public let security: Security
        public init(_ security: Security) {
            self.security = security
        }
    }
}
