//
//  TonalFindEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct TonalSetEvents {
    struct Set: GraniteEvent {
        let range: TonalRange
        public init(_ range: TonalRange) {
            self.range = range
        }
    }
}
