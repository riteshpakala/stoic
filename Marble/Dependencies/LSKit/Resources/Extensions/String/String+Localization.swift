//
//  String+Localization.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self.lowercased(), comment: "")
    }
}
