//
//  TonalSentiment.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import CoreData
import Foundation
import GraniteUI

extension SecurityObject {
    public var sentimentDate: Date {
        self.date.simple.advanced(by: -1)
    }
}

extension TonalSentiment {
    func save(_ range: TonalRange,
              moc: NSManagedObjectContext) -> Bool {
        let result: Bool = moc.performAndWaitPlease {
            let sentimentObjects: [SentimentObject] = self.sounds.values.flatMap { $0 }.map {
                let sentimentObject = SentimentObject(context: moc)
                $0.applyTo(sentimentObject)
                
                //DEV: obv there will be more options in the future
                //
                sentimentObject.sentimentType = SentimentType.social.rawValue
                
                return sentimentObject
            }
            
            let securities = range.expanded
            for security in securities {
                let object = security.getObject(moc: moc)
                if let object = object {
                    let date = object.date.simple
                    object.addToSentiment(
                        NSSet.init(
                            array: sentimentObjects
                                .filter( { $0.date.simple == date })))
                    
                    sentimentObjects.forEach { sentiment in
                        if sentiment.date.simple == object.date {
                            sentiment.security = object
                        }
                    }
                }
            }
            
            do {
                try moc.save()
                GraniteLogger.info("sentiment saved", .utility, focus: true)
                return true
            } catch let error {
                return false
                GraniteLogger.info("sentiment saving failed - \(error.localizedDescription)", .utility)
            }
        }
        
        return result
    }
}
