//
//  AnnouncementEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/13/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

struct AnnouncementEvents {
    public enum Message: Event {
        case welcome
        case upcoming
    }
    
    public struct AnnouncementResponse: Event {
        public let disclaimers: [String]
    }
}
