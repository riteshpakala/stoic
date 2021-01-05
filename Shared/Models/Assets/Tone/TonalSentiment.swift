//
//  TonalSentiment.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//

import Foundation


public struct TonalSentiment {
    let dates: [Date]
    let sounds: [Date: [TonalSound]]
    let datesByDay: [Date]
    let soundsByDay: [Date: [TonalSound]]
    
    let sentiments: [Date: SentimentOutput]
    let sentimentDefaults: [Date: SentimentOutput]
    
    let sentimentsByDay: [Date: SentimentOutput]
    let sentimentDefaultsByDay: [Date: SentimentOutput]
    
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
        datesByDay = uniques.map({ $0.date.asString.asDate() ?? $0.date }).uniques.sorted(by: { $0.compare($1) == .orderedDescending })
        
        var soundsFoundByDay: [Date: [TonalSound]] = [:]
        datesByDay.forEach { date in
            soundsFoundByDay[date] = uniques.filter { $0.date.asString == date.asString }
        }
        self.soundsByDay = soundsFoundByDay
        
        //Setup initial sentiments
        var sentimentDefaultsFound: [Date: SentimentOutput] = [:]
        dates.forEach { date in
            let sentiments = soundsFound[date]?.compactMap { $0.sentiment }
            let posSum = (sentiments?.compactMap { $0.pos }.reduce(0, +) ?? 0.0)
            let negSum = (sentiments?.compactMap { $0.neg }.reduce(0, +) ?? 0.0)
            let neuSum = (sentiments?.compactMap { $0.neu }.reduce(0, +) ?? 0.0)
            let compSum = (sentiments?.compactMap { $0.compound }.reduce(0, +) ?? 0.0)
            let total: Double = (sentiments?.count ?? 0).asDouble
            let avgSentiment = SentimentOutput.init(pos: posSum/total,
                                                    neg: negSum/total,
                                                    neu: neuSum/total,
                                                    compound: compSum/total)
            sentimentDefaultsFound[date] = avgSentiment
        }
        
        self.sentimentDefaults = sentimentDefaultsFound
        self.sentiments = sentimentDefaultsFound
        
        var sentimentDefaultsByDayFound: [Date: SentimentOutput] = [:]
        datesByDay.forEach { date in
            let sentiments = soundsFoundByDay[date]?.compactMap { $0.sentiment }
            let posSum = (sentiments?.compactMap { $0.pos }.reduce(0, +) ?? 0.0)
            let negSum = (sentiments?.compactMap { $0.neg }.reduce(0, +) ?? 0.0)
            let neuSum = (sentiments?.compactMap { $0.neu }.reduce(0, +) ?? 0.0)
            let compSum = (sentiments?.compactMap { $0.compound }.reduce(0, +) ?? 0.0)
            let total: Double = (sentiments?.count ?? 0).asDouble
            let avgSentiment = SentimentOutput.init(pos: posSum/total,
                                                    neg: negSum/total,
                                                    neu: neuSum/total,
                                                    compound: compSum/total)
            sentimentDefaultsByDayFound[date] = avgSentiment
        }
        self.sentimentsByDay = sentimentDefaultsByDayFound
        self.sentimentDefaultsByDay = sentimentDefaultsByDayFound
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
}

