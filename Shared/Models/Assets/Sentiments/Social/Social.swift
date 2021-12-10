//
//  Social.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//

import Foundation
import CoreData

public struct SocialSentiment: Sentiment {
    public var pos: Double
    public var neg: Double
    public var neu: Double
    public var date: Date
    public var compound: Double
    public var content: String
}

extension SocialSentiment {
    public var assetID: String {
        ""
    }
}
