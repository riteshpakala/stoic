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
        .init(self.quotes?.compactMap { $0.asQuote } ?? [],
              self.name,
              self.date,
              self.investmentData?.investments ?? .empty)
    }
}
