//
//  Tone.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//
import SwiftUI
import Foundation
import GraniteUI

public class ToneDependency: GraniteDependable {
    var tone: Tone = .init()
}

public class Tone {
    public struct Constraints {
        public static var maxDays: Int = 30
        public static var minDays: Int = 2
    }
    
    var range: [TonalRange]? {
        didSet {
            find.state = .parsed
        }
    }
    
    public var target: Security? {
        guard let security = selectedRange?.objects.first else {
            GraniteLogger.error("no target security found in the tone dependency\nself:\(String(describing: self))", .dependency)
            return nil
        }
        
        return security
    }
    
    public var latestSecurity: Security? {
        return find.quote?.securities.sortDesc.first
    }
    
    public var baseRange: TonalRange? {
        range?.first(where: { $0.base })
    }
    public var selectedRange: TonalRange? {
        didSet {
            self.set.stage = .fetching
        }
    }
    
    public init(security: Security? = nil,
                range: [TonalRange]? = nil,
                sentiment: TonalSentiment? = nil,
                selectedRange: TonalRange? = nil) {
        
        self.find.security = security
        self.range = range
        self.tune.sentiment = sentiment
        self.selectedRange = selectedRange
    }
    
    // Stages
    public var find: Find = .init()
    public var set: Set = .init()
    public var tune: Tune = .init()
    public var compile: Compile = .init()
    
    public struct Find {
        public enum State {
            case searching
            case selected
            case found
            case parsed
            case none
        }
        
        var state: Find.State = .none {
            didSet {
                lastState = oldValue
            }
        }
        var lastState: Find.State = .none
        
        
        var security: Security? {
            didSet {
                if security != nil {
                    state = .selected
                }
            }
        }
        
        var ticker: String? {
            security?.ticker
        }
        var quote: Quote? {
            didSet {
                if quote != nil && quote?.ticker == ticker {
                    state = .found
                }
            }
        }
        
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
    
    public struct Set {
        public enum State {
            case fetching
            case none
        }
        
        var stage: State = .none
        var state: TonalSetState = .init()
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
            case saved
            case none
        }
        
        var state: Compile.State = .none {
            didSet {
                lastState = oldValue
            }
        }
        var lastState: Compile.State = .none
        
        var model: TonalModels?
        var tonalModel: TonalModel?
        
        var slider: SentimentSliderState
        public init(_ sentimentOutput: SentimentOutput = .neutral) {
            slider = .init(sentimentOutput, date: Date.today)
        }
    }
}
