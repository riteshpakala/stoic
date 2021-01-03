//
//  Tone.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//
import SwiftUI
import Foundation

class Tone: ObservableObject {
    var ticker: String?
    var range: [TonalRange]?
    var sentiment: TonalSentiment?
    var selectedRange: TonalRange?
    
    public init(ticker: String? = nil, range: [TonalRange]? = nil, sentiment: TonalSentiment? = nil, selectedRange: TonalRange? = nil) {
        
        self.ticker = ticker
        self.range = range
        self.sentiment = sentiment
        self.selectedRange = selectedRange
    }
}

class SearchPayload: ObservableObject {
    var query: String = ""
}

struct SearchManager {
    let identifier: String
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    @ObservedObject
    var search: SearchPayload = .init()
}

struct ToneManager {
    let identifier: String
    let urlSession = URLSession.shared
    
    @ObservedObject
    var tone: Tone = .init()
    
    var searchManager: SearchManager = .init(identifier: "search")
}

struct ToneManagerKey: EnvironmentKey {
    typealias Value = ToneManager
    static var defaultValue = ToneManager(identifier: "Default created by environment")
}

struct SearchManagerKey: EnvironmentKey {
    typealias Value = SearchManager
    static var defaultValue = SearchManager(identifier: "Default created by environment")
}

extension EnvironmentValues {
    var toneManager: ToneManager {
        get {
            return self[ToneManagerKey.self]
        }
        set {
            self[ToneManagerKey.self] = newValue
        }
    }
    
    var searchManager: SearchManager {
        get {
            return self[SearchManagerKey.self]
        }
        set {
            self[SearchManagerKey.self] = newValue
        }
    }
}
