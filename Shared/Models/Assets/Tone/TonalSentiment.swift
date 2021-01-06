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
    
    let filteredForRangeByDay: [Date: SentimentOutput]
    
    let range: TonalRange
    
    public init(_ sounds: [TonalSound], range: TonalRange, disparity: Double = 0.04) {
        let uniques = Array(Set(sounds))
        self.range = range
        
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
            let filtered = sentiments?.filter{ abs($0.pos - $0.neg) >= disparity }
            let avgSentiment = filtered?.average(date) ?? .neutral
            sentimentDefaultsFound[date] = avgSentiment
        }
        
        self.sentimentDefaults = sentimentDefaultsFound
        self.sentiments = sentimentDefaultsFound
        
        var sentimentDefaultsByDayFound: [Date: SentimentOutput] = [:]
        datesByDay.forEach { date in
            let sentiments = soundsFoundByDay[date]?.compactMap { $0.sentiment }
            let filtered = sentiments?.filter{ abs($0.pos - $0.neg) >= disparity }
            let avgSentiment = filtered?.average(date) ?? .neutral
            sentimentDefaultsByDayFound[date] = avgSentiment
        }
        self.sentimentsByDay = sentimentDefaultsByDayFound
        self.sentimentDefaultsByDay = sentimentDefaultsByDayFound
        
        let rangeDatesByDay = range.dates.map { $0.simple }
        var rangeDatesByDayFound: [Date: SentimentOutput] = [:]
        rangeDatesByDay.forEach { date in
            let sentimentDate: Date = date.advanced(by: -1)
            if let sentiment = sentimentDefaultsByDayFound[sentimentDate.simple] {
                //LAST LEFT OFF: LLO
                //SENTIMENT NEEDS TO REWIND A DAY
                rangeDatesByDayFound[date] = sentiment
            }
        }
        self.filteredForRangeByDay = rangeDatesByDayFound
    }
    
    public var stats: String {
        """
        dates: \(datesByDay)
        counts: \(soundsByDay.map { $0.value.count })
        """
    }
    
    public static var empty: TonalSentiment {
        .init([], range: .empty)
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

extension Array where Element == SentimentOutput {
    func average(_ date: Date) -> SentimentOutput {
        let posSum = self.compactMap { $0.pos }.reduce(0, +)
        let negSum = self.compactMap { $0.neg }.reduce(0, +)
        let neuSum = self.compactMap { $0.neu }.reduce(0, +)
        let compSum = self.compactMap { $0.compound }.reduce(0, +)
        let total: Double = (self.count).asDouble
        
        return SentimentOutput.init(pos: posSum/total,
                                    neg: negSum/total,
                                    neu: neuSum/total,
                                    compound: compSum/total,
                                    date: date)
    }
}
