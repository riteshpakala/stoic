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

extension Quote {
    public func getObject(moc: NSManagedObjectContext) -> QuoteObject? {
        let request: NSFetchRequest = QuoteObject.fetchRequest()
        request.predicate = NSPredicate(format: "(ticker == %@) AND (exchangeName == %@)",
                                        self.ticker,
                                        self.exchangeName)
        return try? moc.fetch(request).first
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
    
    public func contains(security: Security) -> Bool {
        return self.ticker == security.ticker &&
            self.exchangeName == security.exchangeName &&
            self.securityType == security.securityType.rawValue &&
            self.intervalType == security.interval.rawValue
    }
}
