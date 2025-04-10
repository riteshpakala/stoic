//
//  StockModelObject+CoreDataProperties.swift
//  
//
//  Created by Ritesh Pakala on 9/6/20.
//
//

import Foundation
import CoreData


extension StockModelObject {

    @NSManaged public var date: Double
    @NSManaged public var exchange: String
    @NSManaged public var predictionDays: Int64
    @NSManaged public var sentimentStrength: Int64
    @NSManaged public var ticker: String
    @NSManaged public var sentimentTradingData: Data
    @NSManaged public var historicalTradingData: Data

}
