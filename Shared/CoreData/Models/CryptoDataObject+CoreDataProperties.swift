//
//  CryptoDataObject+CoreDataProperties.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/23/20.
//
//

import Foundation
import CoreData


extension CryptoDataObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CryptoDataObject> {
        return NSFetchRequest<CryptoDataObject>(entityName: "CryptoDataObject")
    }


}
