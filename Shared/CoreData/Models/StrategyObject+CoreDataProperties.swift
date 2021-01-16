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
    @NSManaged public var securities: Set<SecurityObject>?

}

// MARK: Generated accessors for securities
extension StrategyObject {

    @objc(addSecuritiesObject:)
    @NSManaged public func addToSecurities(_ value: SecurityObject)

    @objc(removeSecuritiesObject:)
    @NSManaged public func removeFromSecurities(_ value: SecurityObject)

    @objc(addSecurities:)
    @NSManaged public func addToSecurities(_ values: NSSet)

    @objc(removeSecurities:)
    @NSManaged public func removeFromSecurities(_ values: NSSet)

}

extension StrategyObject : Identifiable {

}
