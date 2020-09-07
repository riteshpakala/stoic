//
//  StockModelParentObject+CoreDataProperties.swift
//  
//
//  Created by Ritesh Pakala on 9/6/20.
//
//

import Foundation
import CoreData


extension StockModelParentObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockModelParentObject> {
        return NSFetchRequest<StockModelParentObject>(entityName: "StockModelParentObject")
    }

    @NSManaged public var id: String
    @NSManaged public var data: Data
    @NSManaged public var merged: NSSet?

}

// MARK: Generated accessors for merged
extension StockModelParentObject {

    @objc(addMergedObject:)
    @NSManaged public func addToMerged(_ value: StockModelMergedObject)

    @objc(removeMergedObject:)
    @NSManaged public func removeFromMerged(_ value: StockModelMergedObject)

    @objc(addMerged:)
    @NSManaged public func addToMerged(_ values: NSSet)

    @objc(removeMerged:)
    @NSManaged public func removeFromMerged(_ values: NSSet)

}
