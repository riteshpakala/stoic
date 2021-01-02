//
//  WindowConfig.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/31/20.
//

import Foundation

public struct WindowConfig: Hashable, Identifiable {
    public class Instance {}
    public struct Index: Hashable, Equatable {
        public static func == (lhs: Index, rhs: Index) -> Bool {
            lhs.x == rhs.x &&
            lhs.y == rhs.y
        }
        
        let x: Int
        let y: Int
        
        static var zero: Index {
            .init(x: 0, y: 0)
        }
    }
    
    var style: WindowStyle = .init()
    var kind: WindowType = .unassigned
    let index: Index
    
    static var none: WindowConfig {
        .init(index: .zero)
    }
    
    var detail: String {
        """
        Window: \(id)
        ------------
        index: (\(index.x), \(index.y))
        kind: \(kind)
        """
    }
    
    public var id: ObjectIdentifier {
        ObjectIdentifier.init(Instance.init())
    }
    
    public static func == (lhs: WindowConfig, rhs: WindowConfig) -> Bool {
        lhs.index == rhs.index
    }
}

public enum WindowType: Hashable {
    case modelCreation
    case savedModels
    case publicModels
    case favorites
    case recents
    case topVolume(SecurityType)
    case winners(SecurityType)
    case losers(SecurityType)
    case securityDetail
    case header
    case search
    case cta
    case modelCarousel
    case portfolio
    case holdings
    case special
    case unassigned
    
    var max: Int {
        switch self {
        case .winners,
             .losers,
             .topVolume,
             .recents,
             .publicModels,
             .modelCarousel :
            return 3
        case .cta:
            return 10000
        default:
            return 1
        }
    }
    
    var label: String {
        switch self {
        case .topVolume(let securityType) :
            return "Top Volume // \("\(securityType)".capitalized)"
        case .winners(let securityType) :
            return "Winners // \("\(securityType)".capitalized)"
        case .losers(let securityType) :
            return "Losers // \("\(securityType)".capitalized)"
        default:
            return ""
        }
    }
}

public struct WindowStyle: Hashable, Equatable {
    public static func == (lhs: WindowStyle, rhs: WindowStyle) -> Bool {
        lhs.idealWidth == rhs.idealWidth &&
        lhs.idealHeight == rhs.idealHeight
    }
    
    
    var idealWidth: CGFloat = 375
    var idealHeight: CGFloat = 420
    
    
    static var minWidth: CGFloat = 300
    static var minHeight: CGFloat = 360
    static var maxWidth: CGFloat = 500
    static var maxHeight: CGFloat = 400
}
