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
    var sentiment: StockSentimentData
    public init(
        payload: ConsoleDetailPayload, sentiment: StockSentimentData) {
        self.payload = payload
        self.sentiment = sentiment
    }
}


//class ThinkPayload: NSObject {
//    var stockSentimentData: StockSentimentData? = nil
//    public init(
//        sentiment: StockSentimentData) {
//        self.stockSentimentData = sentiment
//    }
//}
