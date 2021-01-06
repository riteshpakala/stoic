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

public class Tone: ObservableObject {
    var range: [TonalRange]?
    
    public var target: Security? {
        guard let quote = selectedRange?.objects.first?.quote?.asQuote else {
            print("⚠️ Test prediction failed.")
            return nil
        }
        
        return quote.securities.sortDesc.first
    }
    
    public var baseRange: TonalRange? {
        range?.first(where: { $0.base })
    }
    public var selectedRange: TonalRange?
    
    public init(ticker: String? = nil,
                range: [TonalRange]? = nil,
                sentiment: TonalSentiment? = nil,
                selectedRange: TonalRange? = nil) {
        
        self.find.ticker = ticker
        self.range = range
        self.tune.sentiment = sentiment
        self.selectedRange = selectedRange
    }
    
    // Stages
    public var find: Find = .init()
    public var tune: Tune = .init()
    public var compile: Compile = .init()
    
    public struct Find {
        var ticker: String?
        var quote: QuoteObject?
        
        //DEV:
        //start at the percent of the days selected
        //
        var sliderDays: BasicSliderState = .init()
    }
    
    public struct Tune {
        var tuners: [Date: Tuner] = [:]
        var sentiments: [Date: SentimentOutput] = [:]
        
        //Based on day interval the sentiment slider state would change
        //
        var sentiment: TonalSentiment? {
            didSet {
                if let senti = sentiment {
                    tuners = [:]
                    for date in senti.sentimentDefaultsByDay.keys {
                        tuners[date] = .init(senti.sentimentDefaultsByDay[date] ?? .zero, date: date)
                    }
                }
            }
        }
    }
    
    public struct Tuner {
        var slider: SentimentSliderState
        public init(_ sentimentOutput: SentimentOutput, date: Date) {
            slider = .init(sentimentOutput, date: date)
        }
    }
    
    public struct Compile {
        public enum State {
            case compiled
            case compiling
            case readyToCompile
            case none
        }
        
        var state: Compile.State = .none {
            didSet {
                lastState = oldValue
            }
        }
        var lastState: Compile.State = .none
        
        var model: TonalModels?
        
        var slider: SentimentSliderState
        public init(_ sentimentOutput: SentimentOutput = .neutral) {
            slider = .init(sentimentOutput, date: Date.today)
        }
    }
}
