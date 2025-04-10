//
//  AnnouncementStyle.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/13/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import CoreGraphics

struct AnnouncementStyle {
    public static var privacyHeight: CGFloat {
        if LSConst.Device.isIPad {
            return 240
        } else {
            return 160
        }
    }
    
    public static var imageHeight: CGFloat {
        120
    }
}
