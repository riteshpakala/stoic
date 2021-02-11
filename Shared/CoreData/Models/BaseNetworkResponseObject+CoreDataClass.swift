//
//  BaseNetworkResponse+CoreDataClass.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/11/21.
//
//

import Foundation
import CoreData
import GraniteUI


public class BaseNetworkResponseObject: NetworkResponseObject, CoreDataManaged {
    public typealias Model = BaseNetworkResponseObject
    public static var entityName: String {
        "BaseNetworkResponseObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: BaseNetworkResponseObject.entityName,
            in: context) ?? BaseNetworkResponseObject.entity()
        self.init(entity: entity, insertInto: context)
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: BaseNetworkResponseObject.entityName)
    }
}
