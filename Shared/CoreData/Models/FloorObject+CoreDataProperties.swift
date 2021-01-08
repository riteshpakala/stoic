//
//  FloorObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//
//

import Foundation
import CoreData


extension FloorObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FloorObject> {
        return NSFetchRequest<FloorObject>(entityName: "FloorObject")
    }

    @NSManaged public var securities: Set<SecurityObject>?

}

// MARK: Generated accessors for securities
extension FloorObject {

    @objc(addSecuritiesObject:)
    @NSManaged public func addToSecurities(_ value: SecurityObject)

    @objc(removeSecuritiesObject:)
    @NSManaged public func removeFromSecurities(_ value: SecurityObject)

    @objc(addSecurities:)
    @NSManaged public func addToSecurities(_ values: NSSet)

    @objc(removeSecurities:)
    @NSManaged public func removeFromSecurities(_ values: NSSet)

}

extension FloorObject : Identifiable {

}
