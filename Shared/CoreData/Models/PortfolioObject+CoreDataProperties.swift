//
//  PortfolioObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//
//

import Foundation
import CoreData


extension PortfolioObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PortfolioObject> {
        return NSFetchRequest<PortfolioObject>(entityName: "PortfolioObject")
    }

    @NSManaged public var username: String
    @NSManaged public var floors: Set<FloorObject>?
    @NSManaged public var securities: Set<SecurityObject>?
    @NSManaged public var strategies: Set<StrategyObject>?

}

// MARK: Generated accessors for floor
extension PortfolioObject {

    @objc(addFloorObject:)
    @NSManaged public func addToFloor(_ value: FloorObject)

    @objc(removeFloorObject:)
    @NSManaged public func removeFromFloor(_ value: FloorObject)

    @objc(addFloor:)
    @NSManaged public func addToFloor(_ values: NSSet)

    @objc(removeFloor:)
    @NSManaged public func removeFromFloor(_ values: NSSet)

}

// MARK: Generated accessors for securities
extension PortfolioObject {

    @objc(addSecuritiesObject:)
    @NSManaged public func addToSecurities(_ value: SecurityObject)

    @objc(removeSecuritiesObject:)
    @NSManaged public func removeFromSecurities(_ value: SecurityObject)

    @objc(addSecurities:)
    @NSManaged public func addToSecurities(_ values: NSSet)

    @objc(removeSecurities:)
    @NSManaged public func removeFromSecurities(_ values: NSSet)

}

// MARK: Generated accessors for strategy
extension PortfolioObject {

    @objc(addStrategyObject:)
    @NSManaged public func addToStrategy(_ value: StrategyObject)

    @objc(removeStrategyObject:)
    @NSManaged public func removeFromStrategy(_ value: StrategyObject)

    @objc(addStrategy:)
    @NSManaged public func addToStrategy(_ values: NSSet)

    @objc(removeStrategy:)
    @NSManaged public func removeFromStrategy(_ values: NSSet)

}

extension PortfolioObject : Identifiable {

}
