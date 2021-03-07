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

extension NSManagedObjectContext {
    public func getStrategy(_ name: String) -> Strategy? {
        let request: NSFetchRequest = StrategyObject.fetchRequest()
        request.predicate = NSPredicate(format: "(name == %@)",
                                        name)
        
        let result: Strategy? = self.performAndWaitPlease { [weak self] in
            do {
                if let object = try self?.fetch(request).first {
                    return object.asStrategy
                } else {
                    return nil
                }
            } catch let error {
                GraniteLogger.info("failed to get strategy \(error)", .utility, focus: true)
                return nil
            }
        }
        
        return result
    }
}

extension Strategy {
    public func updated(moc: NSManagedObjectContext) -> Strategy? {
        moc.getStrategy(self.name)
    }
}

extension StrategyObject {
    var asStrategy: Strategy {
        .init(self.quotes?.compactMap { $0.asQuote } ?? [],
              self.name,
              self.date,
              self.investmentData?.investments ?? .empty)
    }
}

