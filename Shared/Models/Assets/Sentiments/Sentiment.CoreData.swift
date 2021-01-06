//
//  Sentiment.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//

import Foundation

extension SentimentObject {
    var asSentiment: SentimentOutput {
        return .init(pos: self.pos,
                     neg: self.neg,
                     neu: self.neu,
                     compound: self.compound,
                     date: self.date)
    }
}
