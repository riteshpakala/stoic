//
//  EnvironmentConfig.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//

import Foundation

public struct EnvironmentConfig {
    public struct Page {
        let windows: [[WindowType]]
    }
    
    public enum PageType {
        case home
        case modelCreate
        case portfolio
        case modelBrowser
        case settings
        
        public var page: Page {
            switch self {
            case .home:
                return .init(windows: [
                             [.topVolume(.stock), .topVolume(.crypto), .portfolio],
                             [.winners(.stock), .winners(.crypto), .favorites],
                             [.losers(.stock), .losers(.crypto), .holdings]
                        ])
            case .portfolio:
                return .init(windows: [
                             [.portfolio, .special, .special],
                             [.favorites, .special, .special],
                             [.holdings, .special, .special]
                        ])
            case .modelCreate:
                return .init(windows: [
                             [.modelCreate(.find), .modelCreate(.tune), .securityPredictor],
                             [.unassigned, .unassigned, .unassigned],
                             [.modelCreate(.set), .unassigned, .unassigned]
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

public struct EnvironmentStyle {
    static var idealWidth: CGFloat = 375
    static var idealHeight: CGFloat = 420
    static var minWidth: CGFloat = 320
    static var minHeight: CGFloat = 120
    static var maxWidth: CGFloat = 500
    static var maxHeight: CGFloat = 400
}
