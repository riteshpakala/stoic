//
//  FindTheToneExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/25/20.
//
import Foundation
import GraniteUI
import Combine
import SwiftUI

struct SetTheToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalSetEvents.Set
    typealias ExpeditionState = TonalSetState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
       
        print("{TEST} selected the range")
        connection.dependency(\TonalCreateDependency.tone.selectedRange, value: event.range)
        
        if let tone = connection.depObject(\TonalCreateDependency.tone.find.quote),
           let quote = tone {
            DispatchQueue.global(qos: .utility).async {
                let time: Double = CFAbsoluteTimeGetCurrent()
                
                let sentimentResult = getSentiment(quote, event.range)
                
                print("⏱⏱⏱⏱⏱⏱\n[Benchmark] Sentiment Fetch - \(CFAbsoluteTimeGetCurrent() - time) \n⏱")
                
                if let sentiment = sentimentResult.sentiment {
                    connection.dependency(\TonalCreateDependency.tone.sentiment, value: sentiment)
                } else {
                    connection.request(TonalEvents.GetSentiment.init(range: sentimentResult.missing ?? event.range), beam: true)
                }
            }
        } else {
            
            connection.request(TonalEvents.GetSentiment.init(range: event.range), beam: true)
        }
    }
    
    //DEV:
    //for now even if a day is missing we will re-route the whole
    //range, but later it should be smarter and handle the missing days
    //and then merge at the end, under the tonalrelay return for the final tonal
    //create submission
    //
    func getSentiment(_ quote: QuoteObject,_ range: TonalRange) -> (sentiment: TonalSentiment?, missing: TonalRange?) {
        
        let dates = range.dates.map { $0.simple }
        let securities = quote.securities.filter { dates.contains($0.date.simple) }
        
        var sounds: [TonalSound] = []
        for security in securities {
            sounds.append(contentsOf: security.sentiment?.compactMap { $0.sound } ?? [])
        }
        let sentiment: TonalSentiment = .init(sounds)
        print("{TEST} \(securities.count) \(sentiment.datesByDay.count)")
        if securities.count == sentiment.datesByDay.count {
            return (sentiment, nil)
        } else {
            let missingSentiment = securities.filter { !sentiment.datesByDay.contains($0.date.simple) }
            
            print(missingSentiment.map { $0.date })
            return (nil, .init(objects: Array(missingSentiment), range.similarities, range.indicators))
        }
        
    }
}

struct TonalSentimentHistoryExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalEvents.History
    typealias ExpeditionState = TonalSetState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        //DEV: Get hits multiple times, need
        //to understand how it's getting hit so many times
        //in the beam event system part of the Tonal Relay
        //
        print(event.sentiment.stats)
        
        if let tone = connection.depObject(\TonalCreateDependency.tone.selectedRange),
           let range = tone {
            save(event.sentiment, range)
        }

        connection.dependency(\TonalCreateDependency.tone.sentiment, value: event.sentiment)
    }
    
    func save(_ sentiment: TonalSentiment, _ range: TonalRange) {
        
        let moc: NSManagedObjectContext
        if Thread.isMainThread {
            moc = coreData.main
        } else {
            moc = coreData.background
        }
        
        moc.perform {
            
            do {
                
                let securityObjects = range.objects
                for object in securityObjects {
                    let date = object.date.simple
                    print("{TEST} \(date) - sentimentCount - \(object.sentiment?.count)")
                    if let sound = sentiment.soundsByDay[date] {
                        let sentimentObjects: [SentimentObject] = sound.map {
                            let sentimentObject = SentimentObject(context: moc)
                            $0.applyTo(sentimentObject)
                            
                            //DEV: obv there will be more options in the future
                            //
                            sentimentObject.sentimentType = SentimentType.social.rawValue
                            
                            return sentimentObject
                        }
                        
                        object.addToSentiment(NSSet.init(array: sentimentObjects))
                    }
                }
                
                try moc.save()
                
                print ("{CoreData} - sentiment saved")
//                completion(quote)
            } catch let error {
                print ("{CoreData} \(error.localizedDescription)")
            }
        }
    }
    
    func getQuote() -> [QuoteObject]? {
        let moc: NSManagedObjectContext
        if Thread.isMainThread {
            moc = coreData.main
        } else {
            moc = coreData.background
        }
        
        return try? moc.fetch(QuoteObject.fetchRequest())
    }
}

//MARK: -- BACKUP

/*
//
//  FindTheToneExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/25/20.
//
import Foundation
import GraniteUI
import Combine

struct FindTheToneExpedition: GraniteExpedition {
    typealias ExpeditionEvent = TonalCreateEvents.Find
    typealias ExpeditionState = TonalCreateState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        let securities = event.quote.securities
        let days: Int = 7
        //
        
        let orderedSecurities = Array(securities.sorted(by: { $0.date.compare($1.date) == .orderedDescending })).filter( { $0.date.compare("2016-01-29".asDate() ?? Date.today) == .orderedDescending } )
        
        let count = orderedSecurities.count
        
        print("{TEST} found \(count)")
        
        var volatilities: [Date:Double] = [:]
        var volatilityCoeffecients: [Date:Double] = [:]
        
        for (index, security) in orderedSecurities.enumerated() {
//            let nextStockIndex = min(index + 1, orderedSecurities.count - 1)
//            let nextStock = orderedSecurities[nextStockIndex]
//            let volatility = security.lastValue - nextStock.lastValue
//            let coeffecient = volatility/nextStock.lastValue
//
//            volatilities[security.date] = volatility
//            volatilityCoeffecients[security.date] = coeffecient
//            let components = security.date.dateComponents()
//            if components.year == 2016, components.month == 1 {
//                print(sum)
//                print(deviations)
//                print(trailing)
//            }
            
            // Standard deviation calculation for yearly variance
            //
            let trailing = orderedSecurities.suffix(orderedSecurities.count - index).prefix(24)
            let sum = trailing.map({ $0.lastValue }).reduce(0.0, +)
            let mean = sum/Double(trailing.count)
            
            let deviations = trailing.map({ pow($0.lastValue - mean, 2) }).reduce(0.0, +)
            let avgDeviation = deviations/Double(trailing.count - 1)
            //            print(mean)
            let standardDeviation = sqrt(avgDeviation)
            volatilities[security.date] = standardDeviation
            volatilityCoeffecients[security.date] = standardDeviation/mean
        }
        
//        for security in orderedSecurities {
//            print("date: \(security.date) // volatilities: \(volatilityCoeffecients[security.date])")
//        }

//
//
//        print("\(orderedSecurities.last?.date)")
        let targetComparables = Array(orderedSecurities.prefix(days))
        
        let chunks = orderedSecurities.chunked(into: days)
        let scrapeTop = Array(chunks.suffix(chunks.count - 1))

        var candidates : [TonalRange] = []
        var coeffecients: [[Double]] = []
        var coeffecientAverages: [Double] = []
        for chunk in scrapeTop {
            guard chunk.count == days else { continue }
            
            
            var similarities: [Double] = []
            for i in 0..<chunk.count {
                let targetCoeffecient = volatilityCoeffecients[targetComparables[i].date] ?? 0.0
                let chunkDayCoeffecient = volatilityCoeffecients[chunk[i].date] ?? 0.0
                similarities.append(targetCoeffecient/chunkDayCoeffecient)
            }
            
//            let sumOfSimilarities = similarities.map({ abs($0) }).reduce(0.0, +)
//            let avgOfSimilarities = sumOfSimilarities/Double(similarities.count)
            
            if similarities.filter( { !($0 <= 1.2 && $0 >= 0.75) } ).isEmpty {
                let dates: [Date] = chunk.map { $0.date }
                
                let tSimilarities: [TonalSimilarity] = dates.enumerated().map {
                    TonalSimilarity.init(date: $0.element,
                                         similarity: similarities[$0.offset]) }
                
                let tIndicators: [TonalIndicators] = dates.map {
                    TonalIndicators.init(date: $0,
                                         volatility: volatilities[$0],
                                         volatilityCoeffecient: volatilityCoeffecients[$0] ) }
//                candidates.append(chunk)
//                coeffecients.append(similarities)
//                coeffecientAverages.append(avgOfSimilarities)
            }
        }
        
//        state.payload = .init(object: state.securityData)
        
        for (index, candidate) in candidates.enumerated() {
            print("%%%%%%%%%%%%%%%%%%")
            print("\(candidates.count) // \(coeffecients.count) // \(coeffecientAverages.count)")
            print("Dates: \(candidate.first?.date)")
            print("Volatilities: \(coeffecients[index])")
            print("Average: \(coeffecientAverages[index])")
        }
        
    }
}

*/
