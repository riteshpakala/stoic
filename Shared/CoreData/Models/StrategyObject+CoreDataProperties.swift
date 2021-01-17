//
//  StrategyObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//
//

import Foundation
import CoreData


extension StrategyObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StrategyObject> {
        return NSFetchRequest<StrategyObject>(entityName: "StrategyObject")
    }
    
    @NSManaged public var date: Date
    @NSManaged public var investmentData: Data?
    @NSManaged public var name: String
    @NSManaged public var quotes: Set<QuoteObject>?
    @NSManaged public var portfolio: PortfolioObject?

}

// MARK: Generated accessors for securities
extension StrategyObject {

    @objc(addQuotesObject:)
    @NSManaged public func addToQuotes(_ value: QuoteObject)

    @objc(removeQuotesObject:)
    @NSManaged public func removeFromQuotes(_ value: QuoteObject)

    @objc(addQuotes:)
    @NSManaged public func addToQuotes(_ values: NSSet)

    @objc(removeQuotes:)
    @NSManaged public func removeFromQuotes(_ values: NSSet)

}

extension StrategyObject : Identifiable {

}
