//
//  StockModelMergedObject+CoreDataClass.swift
//  
//
//  Created by Ritesh Pakala on 9/6/20.
//
//

import Foundation
import CoreData
import Granite

public class StockModelMergedObject: StockModelParentObject, CoreDataManaged {
    public typealias Model = StockModelMergedObject
    public static var entityName: String {
        "StockModelMergedObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: StockModelMergedObject.entityName,
            in: context) ?? StockModelMergedObject.entity()
        self.init(entity: entity, insertInto: context)
        self.id = UUID().uuidString
        self.engine = StockKitUtils.Models.engine
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: StockModelMergedObject.entityName)
    }
}

