//
//  EnvironmentConfig.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//

import Foundation
import SwiftUI
import GraniteUI

#if os(iOS)
import UIKit
#endif

public struct EnvironmentConfig {
    public struct Page {
        let windows: [[WindowType]]
    }
    
    public enum PageType {
        case home
        case intro
        case floor
        case modelCreate(GranitePayload)
        case portfolio
        case modelBrowser
        case securityDetail(GranitePayload)
        case settings
        case discuss
        
        public var page: Page {
            switch self {
            case .intro:
                return .init(windows: [
                    [ .portfolio(.preview) ],
                ])
            case .home:
                return .init(windows: [
                            [ .search, .portfolio(.holdings), .topVolume(.stock), ],
                            [ .unassigned, .unassigned , .unassigned ],
                            [ .unassigned, .tonalBrowser(.empty), .winnersAndLosers(.stock)]
                        ])
            case .modelCreate(let payload):
                return .init(windows: [
                            [.tonalCreate(.find(payload)), .unassigned, .unassigned],
                            [.unassigned, .unassigned, .unassigned],
                            [.tonalCreate(.set), .tonalCreate(.tune), .tonalCreate(.compile)]
                        ])
            case .floor:
                return .init(windows: [
                             [.floor],
                        ])
            case .securityDetail(let payload):
                return .init(windows: [
                            [.securityDetail(.expanded(payload)), .portfolio(.holdings)],
                            [.unassigned, .tonalBrowser(payload)]
                        ])
            case .discuss:
                return .init(windows: [
                    [.discuss]
                ])
            case .settings:
                return .init(windows: [
                    [.settings, .special]
                ])
            default:
                return .init(windows: [])
            }
        }
        
        var broadcastable: Bool {
            switch self {
            case .home:
                return true
            default:
                return false
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
        case .models(let payload):
            return .init(kind: .modelCreate(payload))
        case .securityDetail(let payload):
            return .init(kind: .securityDetail(payload))
        case .intro:
            return .init(kind: .intro)
        case .settings:
            return .init(kind: .settings)
        case .discuss:
            return .init(kind: .discuss)
        default:
            return .init(kind: .home)
        }
    }
}

extension EnvironmentConfig {
    public static var maxWindows: CGSize {
        EnvironmentConfig.isDesktop ? .init(3, 3) : .init(3, 3)
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
    
    public static var iPhoneScreenWidth: CGFloat {
        #if canImport(UIKit)
        return UIScreen.main.bounds.width
        #else
        return 0.0
        #endif
    }
    
    public static var iPhoneScreenHeight: CGFloat {
        #if canImport(UIKit)
        return UIScreen.main.bounds.height - (EnvironmentStyle.ControlBar.iPhone.maxHeight + Brand.Padding.small)
        #else
        return 0.0
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
    
    public struct ControlBar {
        public struct iPhone {
            static var minHeight: CGFloat = 36
            static var maxHeight: CGFloat = 42
        }
        
        public struct Default {
            static var minWidth: CGFloat = 100
            static var maxWidth: CGFloat = 150
        }
    }
    
    public struct Floor {
        public struct iPhone {
            static var minHeight: CGFloat = 36
            static var maxHeight: CGFloat = 42
        }
        
        public struct Default {
            static var minWidth: CGFloat = 100
            static var maxWidth: CGFloat = 150
        }
    }
}
