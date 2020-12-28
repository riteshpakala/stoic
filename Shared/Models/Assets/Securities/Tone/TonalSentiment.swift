//
//  TonalSentiment.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//

import Foundation


struct TonalSentiment {
    let dates: [Date]
    let sounds: [Date: [TonalSound]]
    let datesByDay: [Date]
    let soundsByDay: [Date: [TonalSound]]
    
    public init(_ sounds: [TonalSound]) {
        let uniques = Array(Set(sounds))
        
        dates = uniques.map({ $0.date }).uniques
        
        //By Specific for interval matching
        var soundsFound: [Date: [TonalSound]] = [:]
        dates.forEach { date in
            soundsFound[date] = uniques.filter { $0.date == date }
        }
        self.sounds = soundsFound
        
        //By Day for easy grouping
        datesByDay = uniques.map({ $0.date.asString.asDate() ?? $0.date }).uniques
        
        var soundsFoundByDay: [Date: [TonalSound]] = [:]
        datesByDay.forEach { date in
            soundsFoundByDay[date] = uniques.filter { $0.date.asString == date.asString }
        }
        self.soundsByDay = soundsFoundByDay
    }
    
    public var stats: String {
        """
        dates: \(datesByDay)
        counts: \(soundsByDay.map { $0.value.count })
        """
    }
    
    public static var empty: TonalSentiment {
        .init([])
    }
}

struct TonalSound: Equatable, Hashable {
    static func ==(lhs: TonalSound, rhs: TonalSound) -> Bool {
        return lhs.content == rhs.content
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(content)
    }
    
    let date: Date
    let content: String
    let sentiment: SentimentOutput
}
