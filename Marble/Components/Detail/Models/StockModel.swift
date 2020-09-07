//
//  StockModel.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public class StockModel {
    let searchStock: SearchStock?
    let consoleDetailPayload: ConsoleDetailPayload?
    public init(from object: StockModelObject) {
        self.searchStock = object.stock.asSearchStock
        self.consoleDetailPayload = object.asDetail
    }
}
