//
//  TonalSound.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation

public struct TonalSound: Equatable, Hashable {
    public static func ==(lhs: TonalSound, rhs: TonalSound) -> Bool {
        return lhs.content == rhs.content
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(content)
    }
    
    let date: Date
    let content: String
    let sentiment: SentimentOutput
    
    
    
    public var asString: String {
        """
        🚀🚀🚀🚀🚀🚀
        text: \(content)
        ---------------------
        \(sentiment.asString)
        🚀
        """
    }
}
