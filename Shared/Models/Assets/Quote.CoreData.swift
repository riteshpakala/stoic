//
//  QuoteObject.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import CoreData
import Foundation

extension NSManagedObjectContext {
    public func getQuotes() -> [QuoteObject]? {
        return try? self.fetch(QuoteObject.fetchRequest())
    }
}

extension QuoteObject {
    public var asQuote: Quote {
        .init(intervalType: SecurityInterval(rawValue: self.intervalType) ?? .day,
              ticker: self.ticker,
              securityType: SecurityType(rawValue: self.securityType) ?? .unassigned,
              exchangeName: self.exchangeName,
              securities: self.securities.compactMap { $0.asSecurity })
    }
}
