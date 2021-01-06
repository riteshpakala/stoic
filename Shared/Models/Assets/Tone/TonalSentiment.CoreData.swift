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
    func save(_ range: TonalRange, moc: NSManagedObjectContext) {
        moc.perform {
            do {
                
                let securityObjects = range.expanded
                for object in securityObjects {
                    let date = object.date.simple
                    
                    if let sound = self.soundsByDay[date] {
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
}
