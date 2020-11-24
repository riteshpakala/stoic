//
//  DetailStyle.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

public struct DetailStyle {
    static let consoleSizeExpanded: CGSize = {
        if LSConst.Device.isIPad {
            return .init(
                width: ceil(LSConst.Device.width*0.45),
                height: ceil(LSConst.Device.width*0.5))
        } else {
            return .init(
                width: ceil(LSConst.Device.width*0.9),
                height: ceil(LSConst.Device.width*1.0))
        }
    }()
    
    static let consoleSizePredicting: CGSize = {
        if LSConst.Device.isIPad {
            return .init(
                width: ceil(LSConst.Device.width*0.45),
                height: ceil(LSConst.Device.width*0.28))
        } else {
            return .init(
                width: ceil(LSConst.Device.width*0.9),
                height: ceil(LSConst.Device.width*0.45))
        }
    }()
}
