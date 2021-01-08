//
//  Routes.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/6/21.
//

import Foundation
import GraniteUI
import SwiftUI

public indirect enum Route: ID, Equatable {
    case home
    case floor
    case models
    case settings
    case securityDetail
    case debug(Route)
    case none
    
    var isDebug: Bool {
        switch self{
        case .debug:
            return true
        default:
            return false
        }
    }
}
