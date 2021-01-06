//
//  TonalSentiment.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import Foundation

extension SecurityObject {
    public var sentimentDate: Date {
        self.date.simple.advanced(by: -1)
    }
}
