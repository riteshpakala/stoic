//
//  FloorObject+CoreDataClass.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//
//

import Foundation
import CoreData
import GraniteUI


public class FloorObject: NSManagedObject, CoreDataManaged {
    public typealias Model = FloorObject
    public static var entityName: String {
        "FloorObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: FloorObject.entityName,
            in: context) ?? FloorObject.entity()
        self.init(entity: entity, insertInto: context)
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: FloorObject.entityName)
    }
}
