//
//  Routes.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/6/21.
//

import Foundation
import GraniteUI
import SwiftUI

public indirect enum Route: ID, GraniteRoute, Equatable {
    case home
    case intro
    case floor
    case models(GranitePayload)
    case discuss
    case settings
    case securityDetail(GranitePayload)
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
    
    var isModels: Bool {
        switch self {
        case .models:
            return true
        default:
            return false
        }
    }
    
    public var host: GraniteAdAstra.Type? {
        MainCenter.route
    }
    
    public var home: GraniteAdAstra.Type? {
        EnvironmentCenter.route
    }
}

