//
//  Sentiment.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//

import Foundation

public enum SentimentType: Int64 {
    case social
    case unassigned
}

public protocol Sentiment: Asset {
    var date: Date { get set }
    var content: String { get set }
    var pos: Double { get set }
    var neg: Double { get set }
    var neu: Double { get set }
    var compound: Double { get set }
}

extension Sentiment {
    public var assetType: AssetType {
        .sentiment
    }
}
