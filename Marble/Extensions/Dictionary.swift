//
//  Dictionary.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/11/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public func +<K, V>(left: [K:V], right: [K:V]) -> [K:V] {
    return left.merging(right) { $1 }
}
