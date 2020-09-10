//
//  Array.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/9/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
