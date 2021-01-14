//
//  NetworkResponseObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/13/21.
//
//

import Foundation
import CoreData


extension NetworkResponseObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NetworkResponseObject> {
        return NSFetchRequest<NetworkResponseObject>(entityName: "NetworkResponseObject")
    }

    @NSManaged public var route: String
    @NSManaged public var responseType: String

}

extension NetworkResponseObject : Identifiable {

}
