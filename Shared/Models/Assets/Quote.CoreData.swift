//
//  QuoteObject.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import CoreData
import Foundation

extension NSManagedObjectContext {
    public func getQuotes(_ completion: @escaping(([Quote]) -> Void)) {
        let request: NSFetchRequest = QuoteObject.fetchRequest()
        self.performAndWait {
            if let quotes = try? self.fetch(request) {
                completion(quotes.map { $0.asQuote })
            } else {
                completion([])
            }
        }
    }
}

extension Quote {
    public func getObject(moc: NSManagedObjectContext,
                          _ completion: @escaping((QuoteObject?) -> Void)){
        
        let request: NSFetchRequest = QuoteObject.fetchRequest()
        request.predicate = NSPredicate(format: "(ticker == %@) AND (exchangeName == %@) AND (intervalType == %@)",
                                        self.ticker,
                                        self.exchangeName,
                                        self.intervalType.rawValue)
        
        moc.performAndWait {
            completion(try? moc.fetch(request).first)
        }
    }
}

extension QuoteObject {
    public var asQuote: Quote {
        .init(intervalType: SecurityInterval(rawValue: self.intervalType) ?? .day,
              ticker: self.ticker,
              securityType: SecurityType(rawValue: self.securityType) ?? .unassigned,
              exchangeName: self.exchangeName,
              name: self.name,
              securities: self.securities.compactMap { $0.asSecurity })
    }
    
    public func contains(security: Security) -> Bool {
        return self.ticker == security.ticker &&
            self.exchangeName == security.exchangeName &&
            self.securityType == security.securityType.rawValue &&
            self.intervalType == security.interval.rawValue
    }
}
