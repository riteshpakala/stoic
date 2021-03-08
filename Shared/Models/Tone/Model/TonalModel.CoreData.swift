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
    public func getTones() -> [TonalModelObject] {
        let request: NSFetchRequest = TonalModelObject.fetchRequest()
        
        let result: [TonalModelObject] = self.performAndWaitPlease { [weak self] in
            do {
                return try self?.fetch(request) ?? []
            } catch let error {
                return []
            }
        }
        return result
    }
    public func getTones(forSecurity security: Security) -> [TonalModelObject] {
        
        let quote = security.getQuoteObject(moc: self)
        
        if let model = quote?.tonalModel {
            return Array(model)
        } else {
            return []
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
                     id: self.id,
                     isStrategy: self.isStrategy)
    }
    
    var asToneLight: TonalModel? {
        guard var model = self.model.model,
              let quote = self.quote,
              let range = self.range.tonalRange else {
            
            GraniteLogger.error("TonalModelObject failed to convert to a TonalModel\nsentimentTuners is nil: \(self.sentimentTuners.sentimentTuners == nil)\ntonal model is nil: \(self.model.model == nil)\nquote is nil: \(self.quote == nil)\ntonalRange is nil: \(self.range.tonalRange == nil)", .utility)
            return nil
        }
        
        return .init(model,
                     daysTrained: Int(self.daysTrained),
                     tuners: [],
                     quote: quote.asQuote,
                     range: range,
                     id: self.id,
                     isStrategy: self.isStrategy)
    }
    
    func asToneFromQuote(_ quote: Quote, light: Bool = false) -> TonalModel? {
        guard let sentiment = self.sentimentTuners.sentimentTuners,
              let model = self.model.model,
              let range = self.range.tonalRange else {
            
            GraniteLogger.error("TonalModelObject failed to convert to a TonalModel\nsentimentTuners is nil: \(self.sentimentTuners.sentimentTuners == nil)\ntonal model is nil: \(self.model.model == nil)\nquote is nil: \(self.quote == nil)\ntonalRange is nil: \(self.range.tonalRange == nil)", .utility)
            return nil
        }
        
        return .init(model,
                     daysTrained: Int(self.daysTrained),
                     tuners: light ? [] : sentiment,
                     quote: quote,
                     range: range,
                     id: self.id,
                     isStrategy: self.isStrategy)
    }
}

extension TonalModel {
    func save(moc: NSManagedObjectContext, overwrite: Bool = false) -> Bool {
        guard let modelData = self.david.archived,
              let sentiment = self.tuners.archived,
              let range = self.range.archived else {
            
            return false
        }
        
        let result: Bool = moc.performAndWaitPlease { [weak self] in
            let quote = self?.quote.getObject(moc: moc)
            do {
                let object = TonalModelObject(context: moc)
                object.date = Date.today
                object.daysTrained = Int32(self?.daysTrained ?? 0)
                object.model = modelData
                object.sentimentTuners = sentiment
                object.quote = quote
                object.range = range
                object.isStrategy = self?.isStrategy == true
                quote?.addToTonalModel(object)
                
                if overwrite, let modelID = self?.modelID {
                    object.id = modelID
                    
                    try moc.save()
                    return true
                } else {
                    return false
                }
                
            } catch let error {
                GraniteLogger.error("failed to save tonal model\n\(error)", .utility)
                return false
            }
        }
        
        return result
    }
}
