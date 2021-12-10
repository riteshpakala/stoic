//
//  StrategyObject+CoreDataClass.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//
//

import Foundation
import CoreData
import GraniteUI

public class StrategyObject: NSManagedObject, CoreDataManaged {
    public typealias Model = StrategyObject
    public static var entityName: String {
        "StrategyObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: StrategyObject.entityName,
            in: context) ?? StrategyObject.entity()
        self.init(entity: entity, insertInto: context)
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: StrategyObject.entityName)
    }
}
