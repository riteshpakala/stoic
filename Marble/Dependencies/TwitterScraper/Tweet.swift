//
//  Tweet.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/22/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public class Tweet: NSObject, Codable {
    let text: String
    let time: String
    let lang: String
    
    var date: String {
        if let timeInt = Int(time) {
            return Calendar.nyDateFormatter.string(
                from: Double(timeInt).date())
        } else {
            return ""
        }
    }
    
    public init(text: String, time: String, lang: String) {
        self.text = text
        self.time = time
        self.lang = lang
    }
}
