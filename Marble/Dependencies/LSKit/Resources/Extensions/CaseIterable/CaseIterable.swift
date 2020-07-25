//
//  CaseIterable.swift
//  Wonder
//
//  Created by Ritesh Pakala on 1/12/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

extension CaseIterable where Self: RawRepresentable {

    static var allValues: [RawValue] {
        return allCases.map { $0.rawValue }
    }
}
