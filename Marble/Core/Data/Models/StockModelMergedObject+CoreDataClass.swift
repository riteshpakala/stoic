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
        self.id = UUID().uuidString
        self.version = "david.v0.00.00"
    }
    
    public init(context moc: NSManagedObjectContext) {
        super.init(entity: StockModelMergedObject.entity(), insertInto: moc)
        self.id = UUID().uuidString
        self.version = "david.v0.00.00"
    }
    
    public static func fetchRequest() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: "StockModelMergedObject")
    }
}

