//
//  EventResponder.swift
//  Marble
//
//  Created by Ritesh Pakala on 5/14/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public protocol EventResponder: class {
    func sendEvent(_ event: Event)
    func bubbleEvent(_ event: Event)
}

public protocol Event {
    
}

public struct EventBox {
    let event: Event
    var async: DispatchQueue
    init(
        event: Event,
        async: DispatchQueue = .main) {
        
        self.event = event
        self.async = async
    }
}
