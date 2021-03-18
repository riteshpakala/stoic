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
            
            GraniteLogger.info("failed to retrieve data to appropriately save model", .utility, focus: true)
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
                
                if let modelID = self?.modelID {
                    if overwrite {
                        object.id = modelID
                    }
                    
                    try moc.save()
                    return true
                } else {
                    GraniteLogger.info("failed to save tonal model", .utility, focus: true)
                    return false
                }
                
            } catch let error {
                GraniteLogger.info("failed to save tonal model\n\(error)", .utility, focus: true)
                return false
            }
        }
        
        return result
    }
}

extension TonalModels {
    func save(forQuote quote: Quote,
              range: [Date],
              tuners: [SentimentOutput] = [],
              moc: NSManagedObjectContext,
              overwrite: Bool = false) -> TonalModel? {
        var modelExists: Bool = false
        
        let models = TonalModel.get(forSecurity: quote.latestSecurity,
                                    moc: moc)
        modelExists = models.filter { $0.date == self.created }.isNotEmpty
        
        guard !modelExists else { return nil }
        
        let tonalModel: TonalModel = .init(self,
                                           daysTrained: range.count,
                                           tuners: tuners,
                                           quote: quote,
                                           range: range,
                                           isStrategy: false)
        
        if tonalModel.save(moc: moc, overwrite: overwrite) {
            return tonalModel
        } else {
            return nil
        }
    }
}
