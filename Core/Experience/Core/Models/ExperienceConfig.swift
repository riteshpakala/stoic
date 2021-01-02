//
//  EnvironmentConfig.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//

import Foundation

public struct ExperienceConfig {
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
            default:
                return .init(windows: [])
            }
        }
    }
    
    let kind: PageType
    
    static var none: ExperienceConfig {
        return .init(kind: .home)
    }
}

public struct ExperienceStyle {
    static var idealWidth: CGFloat = 375
    static var idealHeight: CGFloat = 420
    static var minWidth: CGFloat = 320
    static var minHeight: CGFloat = 120
    static var maxWidth: CGFloat = 500
    static var maxHeight: CGFloat = 400
}
