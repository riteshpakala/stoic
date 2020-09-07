//
//  StockModelMergedObject+CoreDataProperties.swift
//  
//
//  Created by Ritesh Pakala on 9/6/20.
//
//

import Foundation
import CoreData

extension StockModelMergedObject {

//    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockModelMergedObject> {
//        return NSFetchRequest<StockModelMergedObject>(entityName: "StockModelMergedObject")
//    }

    @NSManaged public var models: NSOrderedSet?
    @NSManaged public var order: Int64
}

// MARK: Generated accessors for models
extension StockModelMergedObject {

    @objc(insertObject:inModelsAtIndex:)
    @NSManaged public func insertIntoModels(_ value: StockModelParentObject, at idx: Int)

    @objc(removeObjectFromModelsAtIndex:)
    @NSManaged public func removeFromModels(at idx: Int)

    @objc(insertModels:atIndexes:)
    @NSManaged public func insertIntoModels(_ values: [StockModelParentObject], at indexes: NSIndexSet)

    @objc(removeModelsAtIndexes:)
    @NSManaged public func removeFromModels(at indexes: NSIndexSet)

    @objc(replaceObjectInModelsAtIndex:withObject:)
    @NSManaged public func replaceModels(at idx: Int, with value: StockModelParentObject)

    @objc(replaceModelsAtIndexes:withModels:)
    @NSManaged public func replaceModels(at indexes: NSIndexSet, with values: [StockModelParentObject])

    @objc(addModelsObject:)
    @NSManaged public func addToModels(_ value: StockModelParentObject)

    @objc(removeModelsObject:)
    @NSManaged public func removeFromModels(_ value: StockModelParentObject)

    @objc(addModels:)
    @NSManaged public func addToModels(_ values: NSOrderedSet)

    @objc(removeModels:)
    @NSManaged public func removeFromModels(_ values: NSOrderedSet)

}
