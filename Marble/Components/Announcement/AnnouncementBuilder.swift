//
//  AnnouncementBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/13/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

class AnnouncementBuilder {
    static func build(
        _ service: Service,
        state: AnnouncementState = .init()) -> AnnouncementComponent {
        return AnnouncementComponent(
            service,
            .init(),
            AnnouncementViewController())
    }
}
