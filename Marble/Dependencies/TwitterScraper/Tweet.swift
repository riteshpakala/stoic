//
//  Tweet.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/22/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public class Tweet: NSObject, Codable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    
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
    
    public required convenience init?(coder: NSCoder) {
        let text = (coder.decodeObject(forKey: "text") as? String) ?? ""
        let time = (coder.decodeObject(forKey: "time") as? String) ?? ""
        let lang = (coder.decodeObject(forKey: "lang") as? String) ?? ""

        self.init(
            text: text,
            time: time,
            lang: lang)
    }

    public func encode(with coder: NSCoder){
        coder.encode(text, forKey: "text")
        coder.encode(time, forKey: "time")
        coder.encode(lang, forKey: "lang")
    }
}
