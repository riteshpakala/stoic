//
//  SentimentSliderState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class SentimentSliderState: GraniteState {
    var pointX1 = 0.5
    var pointY1 = 0.5
    
    var sentiment: SentimentOutput
    var date: Date
    
    public init(_ sentiment: SentimentOutput, date: Date) {
        self.sentiment = sentiment
        self.date = date
        
        pointX1 = 0.5 + (0.5*(sentiment.pos-sentiment.neg))
        pointY1 = sentiment.neu
    }
    
    required init() {
        sentiment = .zero
        self.date = Date.today
    }
}

public class SentimentSliderCenter: GraniteCenter<SentimentSliderState> {
}
