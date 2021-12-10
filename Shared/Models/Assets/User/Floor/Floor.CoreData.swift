//
//  Floor.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation
import GraniteUI
import CoreData
import CoreGraphics

extension FloorObject {
    var asFloor: Floor {
        .init(self.security?.asSecurity,
              .init(x: CGFloat(self.coordX),
                    y: CGFloat(self.coordY)))
    }
}
