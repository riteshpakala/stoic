//
//  TonalCompileEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct TonalCompileEvents {
    struct Compile: GraniteEvent {
        
        public var async: DispatchQueue? {
            DispatchQueue.init(label: "tonal.model.compile.serial")
        }
    }
}
