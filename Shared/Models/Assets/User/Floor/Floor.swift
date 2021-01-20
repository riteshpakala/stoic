//
//  Floor.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation
import CoreGraphics

public struct Floor {
    var security: Security?
    var location: CGPoint
    var quote: Quote? = nil
    var detail: Detail = .init()
    
    public init(_ security: Security? = nil, _ location: CGPoint) {
        self.security = security
        self.location = location
    }
    
    public static var empty: Floor {
        .init(nil, .zero)
    }
}
