//
//  Tone.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//

import Foundation

struct Tone {
    let range: [TonalRange]?
    let sentiment: TonalSentiment?
    let selectedRange: TonalRange?
    
    public init(range: [TonalRange]? = nil, sentiment: TonalSentiment? = nil, selectedRange: TonalRange? = nil) {
        
        self.range = range
        self.sentiment = sentiment
        self.selectedRange = selectedRange
    }
}
