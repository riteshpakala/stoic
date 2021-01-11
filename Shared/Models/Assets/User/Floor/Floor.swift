//
//  Floor.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation


public struct Floor {
    var securities: [Security] = []
    
    public init(_ securities: [Security] = []) {
        self.securities = securities
    }
}
