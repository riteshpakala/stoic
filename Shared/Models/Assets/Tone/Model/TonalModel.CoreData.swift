//
//  TonalModel.CoreData.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    public func getTones(moc: NSManagedObjectContext) -> [TonalModelObject]? {
        let request: NSFetchRequest = TonalModelObject.fetchRequest()
        
        return try? moc.fetch(request)
    }
}

extension TonalModelObject {
    var asTone: TonalModel? {
        guard let sentiment = self.sentimentTuners.sentimentTuners,
              let model = self.model.model,
              let quote = self.quote,
              let range = self.range.tonalRange else {
            
            print("{TEST} model failed 3 \(self.model.model == nil) \(self.sentimentTuners.sentimentTuners == nil)")
            return nil
        }
        
        return .init(model,
                     daysTrained: Int(self.daysTrained),
                     tuners: sentiment,
                     quote: quote.asQuote,
                     range: range,
                     date: self.date)
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
            do {
                let quote = self.quote.getObject(moc: moc)
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
                print("⚠️ Saving Tonal Model failed. \(error)")
            }
        }
    }
}
