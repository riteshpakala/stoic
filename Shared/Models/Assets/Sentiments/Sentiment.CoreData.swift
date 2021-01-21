//
//  Sentiment.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/4/21.
//

import CoreData
import Foundation
import GraniteUI

extension NSManagedObjectContext {
    //DEV:
    //for now even if a day is missing we will re-route the whole
    //range, but later it should be smarter and handle the missing days
    //and then merge at the end, under the tonalrelay return for the final tonal
    //create submission
    //
    public func getSentiment(_ quote: QuoteObject,
                             _ range: TonalRange,
                             _ completion: @escaping  (((sentiment: TonalSentiment?, missing: TonalRange?)) -> Void)) {
        
        let dates = range.datesExpanded.map { $0.simple }
        let securities = quote.securities
        let securitiesFiltered = securities.filter { dates.contains($0.date.simple) }
         
        self.getSentimentObject(startDate: range.datesExpanded.min() ?? .today,
                                endDate: range.datesExpanded.max() ?? .today,
                                ticker: quote.ticker,
                                exchangeName: quote.exchangeName ) { sentimentObjects in
            
            let sounds: [TonalSound] = sentimentObjects.map({ $0.sound })
          
            let sentiment: TonalSentiment = .init(sounds)
            
            GraniteLogger.info("🪝fetching sentiment\nsenti dates: \(sentimentObjects.map { $0.date.simple }.uniques.sortDesc)\nsecurity dates: \(securitiesFiltered.map { $0.date.simple }.uniques.sortDesc)", .expedition, focus: true)
            
            if sentiment.isValid(against: range) {
                GraniteLogger.info("sentiments valid ✅", .expedition, focus: true)
                completion((sentiment, nil))
            } else {
                let missingSentiment = securitiesFiltered.filter { !sentiment.datesByDay.contains($0.date.simple) }
                
                GraniteLogger.info("sentiments not valid, fetching missing\ndates:\(missingSentiment.map { $0.date.simple })", .expedition, focus: true)
                
                completion((nil, .init(objects: Array(missingSentiment).asSecurities,
                                      Array(securities)
                                        .expanded(from: Array(missingSentiment))
                                        .asSecurities,
                                      range.similarities,
                                      range.indicators)))
            }
        }
    }
    
    public func getSentimentObject(startDate: Date,
                                   endDate: Date,
                                   ticker: String,
                                   exchangeName: String,
                                   _ completion: @escaping (([SentimentObject]) -> Void)) {

        GraniteLogger.info("getting sentiment object with predicate\nstart: \(startDate.advanced(by: -1).simple)\nend: \(endDate.advanceDate(value: 1).simple)", .expedition)
        
        let request: NSFetchRequest = SentimentObject.fetchRequest()
        request.predicate = NSPredicate(format: "(date >= %@) AND (date <= %@) AND (security.ticker == %@) AND (security.exchangeName == %@)",
                                        startDate.advanceDate(value: -1) as NSDate,
                                        endDate.advanceDate(value: 1) as NSDate,
                                        ticker,
                                        exchangeName)
        
        self.performAndWait {
            if let sentiment = try? self.fetch(request) {
                completion(sentiment)
            } else {
                completion([])
            }
        }
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
