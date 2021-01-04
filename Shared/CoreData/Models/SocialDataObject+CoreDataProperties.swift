//
//  SocialDataObject+CoreDataProperties.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//
//

import Foundation
import CoreData


extension SocialDataObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SocialDataObject> {
        return NSFetchRequest<SocialDataObject>(entityName: "SocialDataObject")
    }


}
