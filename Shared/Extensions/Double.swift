//
//  Double.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/20/20.
//

import Foundation

extension Double {
    var format: Double {
        (self * 100).rounded() / 100
    }
}
