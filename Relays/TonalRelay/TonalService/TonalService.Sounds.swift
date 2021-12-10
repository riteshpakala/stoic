//
//  TonalService.Sounds.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/27/20.
//

import Foundation
import SwiftUI

extension TonalServiceModels {
    struct TonalSounds {
        var range: TonalRange? = nil
        var sounds: [[TonalSound]]
        var completed: [Date] = []
        var data: [TonalServiceModels.Tweets]
        var chunks: Int = 1
        
        var dataResults: [TonalServiceModels.Tweets.Meta] {
            data.flatMap { $0.result }
        }
        
        public init() {
            sounds = []
            data = []
        }
        
//        mutating func update(soundChunk: [TonalSound]) {
//            sounds.append(soundChunk)
//            
//            sounds = sounds.filter(
//                {
//                    dates.map {
//                        date in date.asString
//                    }.contains(($0.map { sound in sound.date }.first?.asString ?? "")) == false
//                    
//                } )
//        }
    }
}

extension TonalServiceModels.TonalSounds {
    var datesIngested: [Date] {
        let dates = data.flatMap { tweet in tweet.result.compactMap { $0.date.asDouble.date().simple } }.uniques
        
        return dates.filter({ datesSimple.contains($0.simple.asString) })
    }
    
    var isPrepared: Bool {
        datesIngested.count == dates.count
    }
}

extension TonalServiceModels.TonalSounds {
    var dateParams: (sinceDate: Date, untilDate: Date) {
        guard let sinceDate = range?.dates.last?.advanceDate(value: -1),
              let untilDate = range?.dates.first?.advanceDate(value: range?.base == true ? 0 : 1) else { return (Date.today, Date.today) }
        
        return (sinceDate, untilDate)
    }
    
    var days: Int {
        dateParams.untilDate.daysFrom(dateParams.sinceDate)
    }
    
    var dates: [Date] {
        var dates: [Date] = []
        for day in 0..<days {
            dates.append(dateParams.sinceDate.advanceDate(value: day))
        }
        
        return dates
    }
    
    var datesSimple: [String] {
        dates.map { $0.simple.asString }
    }
    
    func progress(threads: Int, dateChunks: Int) -> Double {
        ((datesIngested.count.asDouble/dates.count.asDouble) * 0.75) +
        ((completed.count.asDouble/chunks.asDouble) * 0.25)
    }
    
    var compiled: [TonalSound] {
        return sounds.flatMap { $0 }
    }
}
