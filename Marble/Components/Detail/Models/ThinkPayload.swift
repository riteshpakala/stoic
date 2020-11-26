//
//  ThinkPayload.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

class ThinkPayload: NSObject {
    var payload: ConsoleDetailPayload
    public init(
        payload: ConsoleDetailPayload) {
        self.payload = payload
    }
}


//class ThinkPayload: NSObject {
//    var stockSentimentData: StockSentimentData? = nil
//    public init(
//        sentiment: StockSentimentData) {
//        self.stockSentimentData = sentiment
//    }
//}
