//
//  DetailEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

struct DetailEvents {
    struct DetailLongPressStarted: Event {
        let translation: CGPoint
    }
    struct DetailLongPressChanged: Event {
        let translation: CGPoint
    }
    struct DetailLongPressEnded: Event {
    }
}

extension DetailEvents {
    struct LoadModel: Event {
        let id: String
    }
    
    struct LoadOffline: Event {
    }
    
    struct GetCSV: Event {
        let ticker: String
    }
    
    struct GetSentiment: Event {
        let ticker: String
    }
    
    struct GetPrediction: Event {
    }
    
    struct PredictionDidUpdate: Event {
        let type: StockKitModels.ModelType
        let value: Double
        let stockSentimentData: StockSentimentData
    }
}

extension DetailEvents {
    struct Think: Event {
    }
    struct ThinkSentimentResponse: Event {
        let sentiment: StockSentimentData
        let tradingDays: [StockDateData]
    }
    struct ThinkResponse: Event {
        let payload: ThinkPayload
    }
}
