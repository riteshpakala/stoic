//
//  Strategy.CoreData.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 1/15/21.
//

import Foundation
import GraniteUI
import CoreData
import CoreGraphics

extension StrategyObject {
    var asStrategy: Strategy {
        .init(self.securities?.compactMap { $0.asSecurity } ?? [],
              self.name,
              self.date,
              self.investmentData?.investments ?? .empty)
    }
}
