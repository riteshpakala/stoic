//
//  TonalModel.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//

import Foundation
import CoreData
import GraniteUI

extension NSManagedObjectContext {
    public func getTones(_ completion: @escaping (([TonalModelObject]) -> Void)) {
        let request: NSFetchRequest = TonalModelObject.fetchRequest()
        self.performAndWait {
            if let tones = try? self.fetch(request) {
                completion(tones)
            } else {
                completion([])
            }
        }
    }
    public func getTones(forSecurity security: Security,
                         _ completion: @escaping (([TonalModelObject]) -> Void)) {
        
        security.getQuoteObject(moc: self) { quote in
            if let model = quote?.tonalModel {
                completion(Array(model))
            } else {
                completion([])
            }
        }
    }
}

extension TonalModelObject {
    var asTone: TonalModel? {
        guard let sentiment = self.sentimentTuners.sentimentTuners,
              let model = self.model.model,
              let quote = self.quote,
              let range = self.range.tonalRange else {
            
            GraniteLogger.error("TonalModelObject failed to convert to a TonalModel\nsentimentTuners is nil: \(self.sentimentTuners.sentimentTuners == nil)\ntonal model is nil: \(self.model.model == nil)\nquote is nil: \(self.quote == nil)\ntonalRange is nil: \(self.range.tonalRange == nil)", .utility)
            return nil
        }
        
        return .init(model,
                     daysTrained: Int(self.daysTrained),
                     tuners: sentiment,
                     quote: quote.asQuote,
                     range: range,
                     date: self.date,
                     id: self.id)
    }
    
    func asToneFromQuote(_ quote: Quote) -> TonalModel? {
        guard let sentiment = self.sentimentTuners.sentimentTuners,
              let model = self.model.model,
              let range = self.range.tonalRange else {
            
            GraniteLogger.error("TonalModelObject failed to convert to a TonalModel\nsentimentTuners is nil: \(self.sentimentTuners.sentimentTuners == nil)\ntonal model is nil: \(self.model.model == nil)\nquote is nil: \(self.quote == nil)\ntonalRange is nil: \(self.range.tonalRange == nil)", .utility)
            return nil
        }
        
        return .init(model,
                     daysTrained: Int(self.daysTrained),
                     tuners: sentiment,
                     quote: quote,
                     range: range,
                     date: self.date,
                     id: self.id)
    }
}

extension TonalModel {
    func save(moc: NSManagedObjectContext, completion: @escaping ((Bool) -> Void)) {
        guard let modelData = self.david.archived,
              let sentiment = self.tuners.archived,
              let range = self.range.archived else {
            
            completion(false)
            return
        }
        
        moc.performAndWait {
            self.quote.getObject(moc: moc) { quote in
                do {
                    let object = TonalModelObject(context: moc)
                    object.date = Date.today
                    object.daysTrained = Int32(self.daysTrained)
                    object.model = modelData
                    object.sentimentTuners = sentiment
                    object.quote = quote
                    object.range = range
                    quote?.addToTonalModel(object)
                    
                    try moc.save()
                    
                    completion(true)
                } catch let error {
                    GraniteLogger.error("failed to save tonal model", .utility)
                    completion(false)
                }
            }
        }
    }
}
