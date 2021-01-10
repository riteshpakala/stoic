//
//  EnvironmentConfig.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit
#endif

public struct EnvironmentConfig {
    public struct Page {
        let windows: [[WindowType]]
    }
    
    public enum PageType {
        case home
        case floor
        case modelCreate
        case portfolio
        case modelBrowser
        case securityDetail
        case settings
        
        public var page: Page {
            switch self {
            case .home:
                return .init(windows: [
                            [ .search, .topVolume(.stock), .portfolio],
                            [ .unassigned, .winners(.stock), .unassigned ],
                            [ .favorites, .losers(.stock), .unassigned]
                        ])
            case .modelCreate:
                return .init(windows: [
                             [.tonalCreate(.find), .tonalCreate(.tune), .tonalCreate(.compile)],
                             [.unassigned, .unassigned, .unassigned],
                             [.tonalCreate(.set), .unassigned, .unassigned]
                        ])
            case .floor:
                return .init(windows: [
                             [.securityDetail(.preview), .securityDetail(.preview), .securityDetail(.preview)],
                             [.securityDetail(.preview), .securityDetail(.preview), .securityDetail(.preview)],
                             [.securityDetail(.preview), .securityDetail(.preview), .securityDetail(.preview)]
                        ])
            case .securityDetail:
                return .init(windows: [
                             [.search, .unassigned, .securityDetail(.preview)],
                             [.unassigned, .unassigned, .unassigned],
                             [.unassigned, .unassigned, .unassigned]
                        ])
            default:
                return .init(windows: [])
            }
        }
    }
    
    let kind: PageType
    
    static var none: EnvironmentConfig {
        return .init(kind: .home)
    }
}

extension EnvironmentConfig {
    public static func route(_ item : Route) -> EnvironmentConfig {
        switch item {
        case .floor:
            return .init(kind: .floor)
        case .models:
            return .init(kind: .modelCreate)
        case .securityDetail:
            return .init(kind: .securityDetail)
        default:
            return .init(kind: .home)
        }
    }
}

extension EnvironmentConfig {
    public static var maxWindows: CGSize {
        EnvironmentConfig.isDesktop ? .init(3, 3) : .init(3, 4)
        //iPad can have 3, although mobile should be 1 width, mobile should also be scrollable the rest fixed
    }
    
    public static var isDesktop: Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
    
    public static var isIPad: Bool {
        #if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .pad
        #else
        return false
        #endif
    }
    
    public static var isIPhone: Bool {
        #if os(iOS)
        return UIDevice.current.userInterfaceIdiom == .phone
        #else
        return false
        #endif
    }
}
public struct EnvironmentStyle {
    static var idealWidth: CGFloat = 375
    static var idealHeight: CGFloat = 420
    static var minWidth: CGFloat = 320
    static var minHeight: CGFloat = 120
    static var maxWidth: CGFloat = 500
    static var maxHeight: CGFloat = 400
}
