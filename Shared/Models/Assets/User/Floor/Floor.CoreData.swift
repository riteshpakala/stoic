//
//  Floor.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation

extension FloorObject {
    var asFloor: Floor {
        .init(Array(self.securities ?? .init()).asSecurities)
    }
}
