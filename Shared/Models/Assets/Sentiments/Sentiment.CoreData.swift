//
//  Sentiment.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//

import CoreData
import Foundation

extension NSManagedObjectContext {
    //DEV:
    //for now even if a day is missing we will re-route the whole
    //range, but later it should be smarter and handle the missing days
    //and then merge at the end, under the tonalrelay return for the final tonal
    //create submission
    //
    public func getSentiment(_ quote: QuoteObject,
                                    _ range: TonalRange) -> (sentiment: TonalSentiment?, missing: TonalRange?)? {
        
        let dates = range.datesExpanded.map { $0.simple }
        let securities = quote.securities
        let securitiesFiltered = securities.filter { dates.contains($0.date.simple) }
        
        guard let sentimentObjects = self.getSentimentObject(
                                        startDate: range.datesExpanded.min() ?? .today,
                                        endDate: range.sentimentShifted.map{ $0.date }.max() ?? .today) else {
            return nil
        }
        
        let sounds: [TonalSound] = sentimentObjects.map({ $0.sound })
      
        let sentiment: TonalSentiment = .init(sounds)
        
        print("🪝🪝🪝🪝🪝🪝\n[Get Sentiment] \(sentimentObjects.count)")
        if sentiment.isValid(against: range) {
            print("valid\n🪝")
            return (sentiment, nil)
        } else {
            let missingSentiment = securitiesFiltered.filter { !sentiment.datesByDay.contains($0.sentimentDate.simple) }
            
            print(missingSentiment.map { $0.date })
            print("missing---\n🪝")
            return (nil, .init(objects: Array(missingSentiment),
                               Array(securities).expanded(from: Array(missingSentiment)),
                               range.similarities,
                               range.indicators))
        }
    }
    
    public func getSentimentObject(startDate: Date,
                                   endDate: Date) -> [SentimentObject]? {
        print("{TEST} \(startDate as NSDate) \(endDate as NSDate)")
        let request: NSFetchRequest = SentimentObject.fetchRequest()
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)",
                                        startDate.advanced(by: -1) as NSDate,
                                        endDate as NSDate)
        return try? self.fetch(request)
    }
}

extension SentimentObject {
    var asSentiment: SentimentOutput {
        return .init(pos: self.pos,
                     neg: self.neg,
                     neu: self.neu,
                     compound: self.compound,
                     date: self.date)
    }
}
