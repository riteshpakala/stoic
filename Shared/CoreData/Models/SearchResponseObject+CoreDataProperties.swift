//
//  SearchResponseObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/13/21.
//
//

import Foundation
import CoreData


extension SearchResponseObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchResponseObject> {
        return NSFetchRequest<SearchResponseObject>(entityName: "SearchResponseObject")
    }

    @NSManaged public var exchangeName: String
    @NSManaged public var symbolName: String
    @NSManaged public var entityDescription: String
    @NSManaged public var id: String?

}
