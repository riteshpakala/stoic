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
        return .init(
            width: LSConst.Device.width*0.9,
            height: LSConst.Device.width*0.9)
    }()
    
    static let consoleSizePredicting: CGSize = {
        return .init(
            width: LSConst.Device.width*0.9,
            height: LSConst.Device.width*0.45)
    }()
}
