//
//  StockModelObject+CoreDataClass.swift
//  
//
//  Created by Ritesh Pakala on 9/6/20.
//
//

import Foundation
import Granite
import CoreData


public class StockModelObject: StockModelParentObject, CoreDataManaged {
    public typealias Model = StockModelObject
    public static var entityName: String {
        "StockModelObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: StockModelObject.entityName,
            in: context) ?? StockModelObject.entity()
        self.init(entity: entity, insertInto: context)
        self.id = UUID().uuidString
        self.engine = StockKitModels.engine
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: StockModelObject.entityName)
    }
}
