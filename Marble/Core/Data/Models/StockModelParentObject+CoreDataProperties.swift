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
    @NSManaged public var version: String
    @NSManaged public var data: Data?
    @NSManaged public var dataSet: Data?
    @NSManaged public var merged: StockModelMergedObject?
    @NSManaged public var stock: Data

}
