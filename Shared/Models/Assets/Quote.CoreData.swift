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
        self.performAndWait { [weak self] in
            if let quotes = try? self?.fetch(request) {
                completion(quotes.map { $0.asQuote })
            } else {
                completion([])
            }
        }
    }
}

extension Quote {
    public func getObjectRequest() -> NSFetchRequest<QuoteObject> {
        let request: NSFetchRequest = QuoteObject.fetchRequest()
        request.predicate = NSPredicate(format: "(ticker == %@) AND (name == %@)",
                                        self.ticker,
                                        self.name)
        
        return request
    }
    
    public func getObject(moc: NSManagedObjectContext,
                          _ completion: @escaping((QuoteObject?) -> Void)){
        
        let request: NSFetchRequest = self.getObjectRequest()
        
        moc.performAndWait {
            completion(try? moc.fetch(request).first)
        }
    }
}

extension QuoteObject {
    public var asQuote: Quote {
        var quote: Quote = .init(ticker: self.ticker,
                              securityType: SecurityType(rawValue: self.securityType) ?? .unassigned,
                              exchangeName: self.exchangeName,
                              name: self.name,
                              securities: self.securities.compactMap { $0.asSecurity })
        
        let models = (self.tonalModel?.compactMap( { $0.asToneFromQuote(quote) }) ?? []).sorted(by: { $0.date.compare($1.date) == .orderedDescending })
        
        quote.models = models
        return quote
    }
    
    public func contains(security: Security) -> Bool {
        return self.ticker == security.ticker &&
            self.name == security.name &&
            self.securityType == security.securityType.rawValue
    }
}
