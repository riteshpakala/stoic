//
//  Tone.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//
import SwiftUI
import Foundation
import GraniteUI

class TonalCreateDependency: DependencyManager {
    @ObservedObject
    var tone: Tone = .init()
    
    @ObservedObject
    var search: SearchQuery = .init()
}

class Tone: ObservableObject {
    var range: [TonalRange]?
    
    
    //Based on day interval the sentiment slider state would change
    //
    var sentiment: TonalSentiment? {
        didSet {
            if let senti = sentiment {
                for date in senti.datesByDay {
                    tuners[date] = .init(senti.sentimentsByDay[date] ?? .zero, date: date)
                }
            }
        }
    }
    
    var selectedRange: TonalRange?
    
    public init(ticker: String? = nil, range: [TonalRange]? = nil, sentiment: TonalSentiment? = nil, selectedRange: TonalRange? = nil) {
        
        self.find.ticker = ticker
        self.range = range
        self.sentiment = sentiment
        self.selectedRange = selectedRange
    }
    
    // Stages
    var find: Find = .init()
    var tuners: [Date: Tune] = [:]
    
    struct Find {
        var ticker: String?
        var quote: QuoteObject?
        
        //DEV:
        //start at the percent of the days selected
        //
        var sliderDays: BasicSliderState = .init()
    }
    
    struct Tune {
        var slider: SentimentSliderState
        public init(_ sentimentOutput: SentimentOutput, date: Date) {
            slider = .init(sentimentOutput, date: date)
        }
    }
}
