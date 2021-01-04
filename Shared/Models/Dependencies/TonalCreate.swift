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
    var sentiment: TonalSentiment?
    var selectedRange: TonalRange?
    
    public init(ticker: String? = nil, range: [TonalRange]? = nil, sentiment: TonalSentiment? = nil, selectedRange: TonalRange? = nil) {
        
        self.find.ticker = ticker
        self.range = range
        self.sentiment = sentiment
        self.selectedRange = selectedRange
    }
    
    // Stages
    var find: Find = .init()
    
    struct Find {
        var ticker: String?
        var quote: QuoteObject?
        var sliderDays: BasicSliderState = .init()
    }
}
