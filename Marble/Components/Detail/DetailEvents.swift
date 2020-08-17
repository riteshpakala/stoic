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
    struct GetCSV: Event {
        let ticker: String
    }
    
    struct GetSentiment: Event {
        let ticker: String
    }
    
    struct GetPrediction: Event {
    }
}

extension DetailEvents {
    struct Think: Event {
    }
    struct ThinkResponse: Event {
        let payload: ThinkPayload
    }
}
