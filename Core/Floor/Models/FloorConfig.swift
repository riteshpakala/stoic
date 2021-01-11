//
//  FloorConfig.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation

public struct FloorConfig {
    public static var maxWindows: CGSize {
        EnvironmentConfig.isDesktop ? .init(3, 3) : .init(3, 4)
        //iPad can have 3, although mobile should be 1 width, mobile should also be scrollable the rest fixed
    }
}
