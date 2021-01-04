//
//  SocialDataObject+CoreDataClass.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//
//

import GraniteUI
import Foundation
import CoreData


public class SocialDataObject: SentimentObject, CoreDataManaged {
    public typealias Model = SocialDataObject
    public static var entityName: String {
        "SocialDataObject"
    }
    
    public override init(
        entity: NSEntityDescription,
        insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    convenience init(context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(
            forEntityName: SocialDataObject.entityName,
            in: context) ?? SocialDataObject.entity()
        self.init(entity: entity, insertInto: context)
    }
    
    public static func request() -> NSFetchRequest<Model> {
        return NSFetchRequest<Model>(entityName: SocialDataObject.entityName)
    }
}
