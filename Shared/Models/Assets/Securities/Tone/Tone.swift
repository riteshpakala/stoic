//
//  Tone.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//
import SwiftUI
import Foundation
import GraniteUI

class Tone: ObservableObject {
    var ticker: String?
    var range: [TonalRange]?
    var sentiment: TonalSentiment?
    var selectedRange: TonalRange?
    var quote: QuoteObject?
    
    public init(ticker: String? = nil, range: [TonalRange]? = nil, sentiment: TonalSentiment? = nil, selectedRange: TonalRange? = nil) {
        
        self.ticker = ticker
        self.range = range
        self.sentiment = sentiment
        self.selectedRange = selectedRange
    }
    
    var sliderDays: BasicSliderState = .init()
}

class SearchQuery: ObservableObject {
    var state: SearchState = .init()
    var securities: [Security] = []
}

class SearchDependency: DependencyManager {
    @ObservedObject
    var search: SearchQuery = .init()
}

class TonalCreateDependency: DependencyManager {
    @ObservedObject
    var tone: Tone = .init()
    
    @ObservedObject
    var search: SearchQuery = .init()
}
