//
//  FloorConfig.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation
import CoreGraphics

public struct FloorConfig {
    public static var maxWindows: CGSize {
        EnvironmentConfig.isDesktop ? .init(3, 3) : .init(3, 3)
        //iPad can have 3, although mobile should be 1 width, mobile should also be scrollable the rest fixed
    }
}
