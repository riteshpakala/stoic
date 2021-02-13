//
//  FloorEvents.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct FloorEvents {
    public struct Get: GraniteEvent {
    }
    
    public struct AddToFloor: GraniteEvent {
        let location: CGPoint
    }
    
    public struct ExitAddToFloor: GraniteEvent {
    }
}
