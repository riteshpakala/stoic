//
//  StockKitEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct StockKitEvents {
    struct StockKitIsPrepared: Event {
    }
    struct GetValidMarketDays: Event {
    }
    struct ValidMarketDaysCompleted: Event {
        let result: [StockDateData]
    }
    struct SearchCompleted: Event {
        let result: [[String: String]]
    }
    struct CSVDownloadCompleted: Event {
        let result: [StockData]
    }
    struct CSVProgress: Event {
        let fraction: Double
    }
    struct SentimentDigetsCompleted: Event {
        let result: [StockSentimentData]
    }
    struct SentimentProgress: Event {
        let text: String?
        let fraction: Double
    }
    struct PredictionProgress: Event {
        let maxIterations: Int
        let iterations: Int
    }
}
