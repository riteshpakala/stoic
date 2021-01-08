//
//  PortfolioObject+CoreDataClass.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//
//

import Foundation
import CoreData
import GraniteUI

public class PortfolioObject: NSManagedObject, CoreDataManaged {
    public typealias Model = PortfolioObject
    public static var entityName: String {
        "PortfolioObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: PortfolioObject.entityName,
            in: context) ?? PortfolioObject.entity()
        self.init(entity: entity, insertInto: context)
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: PortfolioObject.entityName)
    }
}
