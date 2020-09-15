//
//  StockModelParentObject+CoreDataProperties.swift
//  
//
//  Created by Ritesh Pakala on 9/6/20.
//
//

import Foundation
import CoreData


extension StockModelParentObject {

    @NSManaged public var id: String
    @NSManaged public var engine: String
    @NSManaged public var model: Data?
    @NSManaged public var dataSet: Data?
    @NSManaged public var merged: StockModelMergedObject?
    @NSManaged public var stock: Data
    @NSManaged public var timestamp: Double

}
