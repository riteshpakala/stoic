//
//  TonalSound.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//

import Foundation
import CoreData


extension TonalSound {
    func applyTo(_ sentimentObject: SentimentObject) {
        sentimentObject.content = self.content
        sentimentObject.compound = self.sentiment.compound
        sentimentObject.pos = self.sentiment.pos
        sentimentObject.neu = self.sentiment.neu
        sentimentObject.neg = self.sentiment.neg
        sentimentObject.date = self.date
    }
}

extension SentimentObject {
    var sound: TonalSound {
        .init(
            date: self.date,
            content: self.content,
            sentiment: .init(pos: self.pos,
                             neg: self.neg,
                             neu: self.neu,
                             compound: self.compound))
    }
}
