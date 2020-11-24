import Foundation
import Granite
import CoreData

extension ServiceCenter {
    func getMergedStockModels(from: CoreDataThread) -> [StockModelMergedObject]? {
        switch from {
        case .background:
            return try? self.coreData.background.fetch(StockModelMergedObject.request())
        case .main:
            return try? self.coreData.main.fetch(StockModelMergedObject.request())
        }
    }
    
    func getStockModels(from: CoreDataThread) -> [StockModelObject]? {
        switch from {
        case .background:
            return try? self.coreData.background.fetch(StockModelObject.request())
        case .main:
            return try? self.coreData.main.fetch(StockModelObject.request())
        }
    }
    
    func saveStockPredictions(
        _ prediction: StockModelObjectPayload,
        with context: CoreDataThread) -> String? {
        
        let moc: NSManagedObjectContext
        
        switch context {
        case .background:
            moc = coreData.background
        case .main:
            moc = coreData.main
        }
        
        guard let preparedData = ServiceCenter.prepareData(from: prediction) else {
            return nil
        }
        
        let uid: String = UUID.init().uuidString
        moc.perform {
            let mergedModels: [StockModelMergedObject]? = try? moc.fetch(StockModelMergedObject.request())
            let mergedModel = mergedModels?.first(where: { $0.stock.asSearchStock?.symbol == prediction.stock.symbol && $0.stock.asSearchStock?.exchangeName == prediction.stock.exchangeName })
            let merged = mergedModel ?? StockModelMergedObject.init(context: moc)
            
            if mergedModel == nil {
                merged.stock = preparedData.stock
                merged.order = Int64(mergedModels?.count ?? 0)
                merged.timestamp = Date().timeIntervalSince1970
            }
            
            let object = StockModelObject.init(context: moc)
            object.model = preparedData.modelData
            object.date = prediction.date.asDate?.timeIntervalSince1970 ?? 0.0
            object.predictionDays = Int64(prediction.predictionDays)
            object.sentimentStrength = Int64(prediction.sentimentStrength)
            object.ticker = prediction.stock.symbolName ?? ""
            object.exchange = prediction.stock.exchangeName ?? ""
            object.sentimentTradingData = preparedData.sentimentData
            object.historicalTradingData = preparedData.historicalData
            object.stock = preparedData.stock
            object.timestamp = Date().timeIntervalSince1970
            object.id = uid
            
            merged.addToModels(object)
            
            do {
                try moc.save()
            } catch let error {
                print ("{CoreData} \(error.localizedDescription)")
            }
        }
        
        return uid
    }
    
    public static func prepareData(
        from prediction: StockModelObjectPayload) ->
        (modelData: Data, sentimentData: Data, historicalData: Data, stock: Data)? {
            
        let modelData: Data? = prediction.models.archived
        
        let sentimentData: Data?
        do {
            sentimentData = try NSKeyedArchiver
                                .archivedData(
                                    withRootObject: prediction.sentimentData,
                                    requiringSecureCoding: true)
        } catch let error {
            sentimentData = nil
            print("{CoreData} sentiment \(error)")
        }
        
        let historicalData: Data?
        do {
            
            historicalData = try NSKeyedArchiver
                                .archivedData(
                                    withRootObject: prediction.historicalData,
                                    requiringSecureCoding: true)
        } catch let error {
            historicalData = nil
            print("{CoreData} historical \(error)")
        }
            
        let searchStockData: Data?
        do {
            
            searchStockData = try NSKeyedArchiver
                                .archivedData(
                                    withRootObject: prediction.stock,
                                    requiringSecureCoding: true)
        } catch let error {
            searchStockData = nil
            print("{CoreData} historical \(error)")
        }
        
        guard let model = modelData,
            let sentiment = sentimentData,
            let historical = historicalData,
            let stock = searchStockData else {
            
            return nil
        }
        
        return (model, sentiment, historical, stock)
    }
}

public class StockModelObjectPayload: NSObject {
    let date: StockDateData
    let models: StockKitModels
    let stock: SearchStock
    let sentimentStrength: Int
    let predictionDays: Int
    let sentimentData: [StockSentimentData]
    let historicalData: [StockData]
    
    public init(
        date: StockDateData,
        models: StockKitModels,
        stock: SearchStock,
        sentimentStrength: Int,
        predictionDays: Int,
        sentimentData: [StockSentimentData],
        historicalData: [StockData]) {
        self.date = date
        self.models = models
        self.stock = stock
        self.sentimentStrength = sentimentStrength
        self.predictionDays = predictionDays
        self.sentimentData = sentimentData
        self.historicalData = historicalData
    }
}

extension NSObject {
    public var archived: Data? {
        do {
            return try NSKeyedArchiver
                .archivedData(
                    withRootObject: self,
                    requiringSecureCoding: true)
        } catch let error {
            print("{CoreData} \(error.localizedDescription)")
            return nil
        }
    }
}

extension Array where Element == String {
    public var archived: Data? {
        return try? JSONEncoder().encode(self)
    }
}

extension Data {
    public var model: StockKitModels? {
        
        do {
            if let object = try NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(self) as? StockKitModels {
                return object
            }
        } catch let error {
            print("{CoreData} \(error)")
        }
        
        return nil
    }
    
    public var asStockData: [StockData]? {
        do {
           if let object = try NSKeyedUnarchiver
               .unarchiveTopLevelObjectWithData(self) as? [StockData] {
               return object
           }
        } catch let error {
           print("{CoreData} \(error)")
        }
        
        return nil
    }
    
    public var asStockSentimentData: [StockSentimentData]? {
        do {
           if let object = try NSKeyedUnarchiver
               .unarchiveTopLevelObjectWithData(self) as? [StockSentimentData] {
               return object
           }
        } catch let error {
           print("{CoreData} \(error)")
        }
        
        return nil
    }
    
    public var asSearchStock: SearchStock? {
        do {
           if let object = try NSKeyedUnarchiver
               .unarchiveTopLevelObjectWithData(self) as? SearchStock {
               return object
           }
        } catch let error {
           print("{CoreData} \(error)")
        }
        
        return nil
    }
    
    public var mergedModelIDs: [String]? {
        return (try? JSONDecoder().decode([String].self, from: self))
    }
}

extension StockModelObject {
    var asDetail: ConsoleDetailPayload? {
        guard let model = self.model?.model,
            let sentiment = self.sentimentTradingData.asStockSentimentData,
            let historical = self.historicalTradingData.asStockData else {
            
            return nil
        }
        
        return .init(
            currentTradingDay: self.date.date().asString,
            historicalTradingData: historical,
            stockSentimentData: sentiment,
            days: Int(self.predictionDays),
            maxDays: Int(self.predictionDays),
            model: model)
    }
}

extension StockModelMergedObject {
    var asModel: StockModel {
        return StockModel.init(fromMerged: self)
    }
    
    var date: Date? {
        if let models = self.models {
            guard let mutableLogs: NSMutableOrderedSet = models.mutableCopy() as? NSMutableOrderedSet else {
                return nil
            }
            let sd = NSSortDescriptor(key: "date", ascending: false)
            mutableLogs.sort(using: [sd])
            
            let ids = self.currentModels?.mergedModelIDs
            
            let obj = mutableLogs.first(where: {
                if  let obj = ($0 as? StockModelObject),
                    ids?.contains(obj.id) == true {
                    
                    return true
                } else {
                    return false
                }
            })
            
            return (obj as? StockModelObject)?.date.date()
        } else {
            return nil
        }
    }
}
