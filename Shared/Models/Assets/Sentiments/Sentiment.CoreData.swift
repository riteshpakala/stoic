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
                                        endDate: range.datesExpanded.max() ?? .today,
                                        ticker: quote.ticker,
                                        exchangeName: quote.exchangeName ) else {
            return nil
        }
        
        let sounds: [TonalSound] = sentimentObjects.map({ $0.sound })
      
        let sentiment: TonalSentiment = .init(sounds)
        
        print("🪝🪝🪝🪝🪝🪝\n[Get Sentiment] ")
        
        print("SentimentDates: \(sentimentObjects.map { $0.date.simple }.uniques.sortDesc)")
        print("SecurityDates: \(securitiesFiltered.map { $0.date.simple }.uniques.sortDesc)")
        
        if sentiment.isValid(against: range) {
            print("valid\n🪝")
            return (sentiment, nil)
        } else {
            let missingSentiment = securitiesFiltered.filter { !sentiment.datesByDay.contains($0.date.simple) }
            
            print("\n🪝 ")
            return (nil, .init(objects: Array(missingSentiment).asSecurities,
                               Array(securities)
                                .expanded(from: Array(missingSentiment))
                                .asSecurities,
                               range.similarities,
                               range.indicators))
        }
    }
    
    public func getSentimentObject(startDate: Date,
                                   endDate: Date,
                                   ticker: String,
                                   exchangeName: String) -> [SentimentObject]? {
        print("{TEST} \(startDate.advanced(by: -1) as NSDate) \(endDate.advanceDate(value: 1) as NSDate)")
        let request: NSFetchRequest = SentimentObject.fetchRequest()
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@) AND (security.ticker == %@) AND (security.exchangeName == %@)",
                                        startDate.advanceDate(value: -1) as NSDate,
                                        endDate.advanceDate(value: 1) as NSDate,
                                        ticker,
                                        exchangeName)
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
