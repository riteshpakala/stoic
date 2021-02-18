//
//  AssetSectionEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct AssetSectionEvents {
    public struct Refresh: GraniteEvent {
        let sync: Bool
        public init(sync: Bool = false){
            self.sync = sync
        }
    }
}
