//
//  Tone.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//
import SwiftUI
import Foundation
import GraniteUI

public class Tone: ObservableObject {
    public struct Constraints {
        public static var maxDays: Int = 30
        public static var minDays: Int = 4
    }
    
    
    var range: [TonalRange]?
    
    public var target: Security? {
        guard let security = selectedRange?.objects.first else {
            print("⚠️ Test prediction failed.")
            return nil
        }
        
        return security
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
        public enum State {
            case searching
            case found
            case selected
            case none
        }
        
        var state: Find.State = .none {
            didSet {
                lastState = oldValue
            }
        }
        var lastState: Find.State = .none
        
        var ticker: String?
        var quote: Quote?
        
        //DEV:
        //start at the percent of the days selected
        //
        var sliderDays: BasicSliderState = .init()
        
        var daysSelected: Int {
            let dayDiff: Double = Double(Tone.Constraints.maxDays - Tone.Constraints.minDays)
            let days: Double = sliderDays.number*dayDiff
            return Int(days) + Tone.Constraints.minDays
        }
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
