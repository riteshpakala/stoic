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
        
        public init() {
            sounds = []
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
    var dateParams: (sinceDate: Date, untilDate: Date) {
        guard let sinceDate = range?.dates.last?.advanceDate(value: -2),
              let untilDate = range?.dates.first?.advanceDate(value: 1) else { return (Date.today, Date.today) }
        
        return (sinceDate, untilDate)
    }
    
    var days: Int {
        abs(dateParams.untilDate.timeIntervalSince(dateParams.sinceDate).date().dateComponents().day)
    }
    
    var dates: [Date] {
        var dates: [Date] = []
        for day in 0..<days {
            dates.append(dateParams.sinceDate.advanceDate(value: day))
        }
        
        return dates
    }
    
    func progress(threads: Int, dateChunks: Int) -> Double {
        sounds.count.asDouble / (dates.count * threads).asDouble
    }
    
    var compiled: [TonalSound] {
        return sounds.flatMap { $0 }
    }
}
