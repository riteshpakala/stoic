//
//  BaseNetworkResponse+CoreDataProperties.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/11/21.
//
//

import Foundation
import CoreData


extension BaseNetworkResponseObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BaseNetworkResponseObject> {
        return NSFetchRequest<BaseNetworkResponseObject>(entityName: "BaseNetworkResponseObject")
    }


}
