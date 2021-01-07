//
//  WindowConfig.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/31/20.
//

import Foundation
import GraniteUI
import SwiftUI

public struct WindowConfig: Hashable, Identifiable {
    public var id: ObjectIdentifier {
        return .init(Instance.init(name: ""))
    }
    
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
    
    public static func == (lhs: WindowConfig, rhs: WindowConfig) -> Bool {
        lhs.index == rhs.index
    }
}

public enum WindowType: Hashable {
    case savedModels
    case publicModels
    
    case favorites
    case recents
    
    case topVolume(SecurityType)
    case winners(SecurityType)
    case losers(SecurityType)
    
    case securityDetail(SecurityDetailType)
    
    case search
    
    case cta
    
    case modelCarousel
    
    case portfolio
    case holdings
    
    case special
    
    case modelCreate(TonalCreateStage)
    
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
            return "top volume"
        case .winners(let securityType) :
            return "winners"
        case .losers(let securityType) :
            return "losers"
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
    
    static var windowSizeProxy: some View {
        GeometryReader { reader in
            Rectangle().frame(width: reader.size.width, height: reader.size.height, alignment: .center)
        }
    }
}
