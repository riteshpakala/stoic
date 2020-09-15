//
//  SubscribeStyle.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

struct SubscribeStyle {
    static var optionSize: CGSize {
        if LSConst.Device.isIPhoneX {
            return .init(width: 60, height: 90)
        } else {
            return .init(width: 60, height: 120)
        }
    }
    
    static var imageSize: CGSize {
        if LSConst.Device.isIPhoneX {
            return .init(width: 60, height: 180)
        } else {
            return .init(width: 60, height: 240)
        }
    }
}
