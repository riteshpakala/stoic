//
//  TonalSentiment.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//

import CoreData
import Foundation

extension SecurityObject {
    public var sentimentDate: Date {
        self.date.simple.advanced(by: -1)
    }
}

extension TonalSentiment {
    func save(_ range: TonalRange, moc: NSManagedObjectContext, completion: ((Bool) -> Void)? = nil) {
        moc.performAndWait {
            do {
                
                let sentimentObjects: [SentimentObject] = self.sounds.values.flatMap { $0 }.map {
                    let sentimentObject = SentimentObject(context: moc)
                    $0.applyTo(sentimentObject)
                    
                    //DEV: obv there will be more options in the future
                    //
                    sentimentObject.sentimentType = SentimentType.social.rawValue
                    
                    return sentimentObject
                }
                
                let securities = range.expanded
                let securityObjects = securities.compactMap({ $0.getObject(moc: moc) })
                
                for object in securityObjects {
                    let date = object.date.simple
                    print("{TEST} saving = \(date)")
                    object.addToSentiment(
                        NSSet.init(
                            array: sentimentObjects
                                .filter( { $0.date.simple == date })))
                }
                
                try moc.save()
                print ("{CoreData} - sentiment saved")
                completion?(true)
//                completion(quote)
            } catch let error {
                completion?(false)
                print ("{CoreData} \(error.localizedDescription)")
            }
        }
    }
}
