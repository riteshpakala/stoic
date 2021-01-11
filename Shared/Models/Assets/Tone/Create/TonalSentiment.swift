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
    
    public init(_ sounds: [TonalSound], disparity: Double = 0.04) {
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
    }
    
    //DEV: fix
    public func isValid(against range: TonalRange) -> Bool {
        guard let expandedMax = range.datesExpanded.max(),
              let expandedMin = range.datesExpanded.min() else {
            return false
        }
        
        guard let sentimentMax = self.datesByDay.max(),
              let sentimentMin = self.datesByDay.min() else {
            return false
        }
        
        return sentimentMax.simple.isGreaterOrEqual(
            to: expandedMax.simple) &&
            sentimentMin.simple.isLessOrEqual(
                to: expandedMin.simple)
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
