//
//  AnnouncementComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/13/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class AnnouncementComponent: Component<AnnouncementState> {
    override public var reducers: [AnyReducer] {
        [
            AnnouncementReducer.Reducible(),
            AnnouncementResponseReducer.Reducible()
        ]
    }
    
    override public func didLoad() {
        switch state.displayType {
        case .remote:
            if !service.center.welcomeCompleted {
                sendEvent(AnnouncementEvents.Message.welcome)
            } else {
                sendEvent(AnnouncementEvents.Message.upcoming)
            }
        default: break
        }
    }
}
