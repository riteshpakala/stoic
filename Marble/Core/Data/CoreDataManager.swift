import Foundation
import Granite
import CoreData

extension ServiceCenter {
    func getMergedStockModels(from: CoreDataThread) -> [StockModelMergedObject]? {
        switch from {
        case .background:
            return try? self.coreData.background.fetch(StockModelMergedObject.fetchRequest())
        case .main:
            return try? self.coreData.main.fetch(StockModelMergedObject.fetchRequest())
        }
    }
    
    func getStockModels(from: CoreDataThread) -> [StockModelObject]? {
        switch from {
        case .background:
            return try? self.coreData.background.fetch(StockModelObject.fetchRequest())
        case .main:
            return try? self.coreData.main.fetch(StockModelObject.fetchRequest())
        }
    }
    
    func saveStockPredictions(
        _ prediction: StockModelObjectPayload,
        with context: CoreDataThread) {
        
        let moc: NSManagedObjectContext
        
        switch context {
        case .background:
            moc = coreData.background
        case .main:
            moc = coreData.main
        }
        
        guard let preparedData = ServiceCenter.prepareData(from: prediction) else {
            return
        }
        
        
        moc.perform {
            let mergedModels: [StockModelMergedObject]? = try? moc.fetch(StockModelMergedObject.fetchRequest())
            let mergedModel = mergedModels?.first(where: { $0.stock.asSearchStock?.symbol == prediction.stock.symbol && $0.stock.asSearchStock?.exchangeName == prediction.stock.exchangeName })
            let merged = mergedModel ?? StockModelMergedObject.init(context: moc)
            
            if mergedModel == nil {
                merged.stock = preparedData.stock
                merged.order = Int64(mergedModels?.count ?? 0)
            }
            
            let object = StockModelObject.init(context: moc)
            object.data = preparedData.modelData
            object.date = prediction.date.asDate?.timeIntervalSince1970 ?? 0.0
            object.predictionDays = Int64(prediction.predictionDays)
            object.sentimentStrength = Int64(prediction.sentimentStrength)
            object.ticker = prediction.stock.symbolName ?? ""
            object.exchange = prediction.stock.exchangeName ?? ""
            object.sentimentTradingData = preparedData.sentimentData
            object.historicalTradingData = preparedData.historicalData
            object.stock = preparedData.stock
            object.dataSet = preparedData.dataSet
            
            merged.addToModels(object)
            
            do {
                try moc.save()
            } catch let error {
                print ("{CoreData} \(error.localizedDescription)")
            }
        }
    }
    
    public static func prepareData(
        from prediction: StockModelObjectPayload) ->
        (modelData: Data, sentimentData: Data, historicalData: Data, stock: Data, dataSet: Data)? {
            
        let modelData: Data?
        do {
            modelData = try NSKeyedArchiver
                .archivedData(
                    withRootObject: prediction.data,
                    requiringSecureCoding: true)
        } catch let error {
            modelData = nil
            print("{CoreData} \(error.localizedDescription)")
        }
        
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
            
        let dataSetData: Data?
        do {
            
            dataSetData = try NSKeyedArchiver
                                .archivedData(
                                    withRootObject: prediction.dataSet,
                                    requiringSecureCoding: true)
        } catch let error {
            dataSetData = nil
            print("{CoreData} historical \(error)")
        }
        
        guard let model = modelData,
            let sentiment = sentimentData,
            let historical = historicalData,
            let stock = searchStockData,
            let dataSet = dataSetData else {
            
            return nil
        }
        
        return (model, sentiment, historical, stock, dataSet)
    }
}

public class StockModelObjectPayload: NSObject {
    let date: StockDateData
    let data: NSDictionary
    let stock: SearchStock
    let sentimentStrength: Int
    let predictionDays: Int
    let sentimentData: [StockSentimentData]
    let historicalData: [StockData]
    let dataSet: DataSet
    
    public init(
        date: StockDateData,
        data: NSDictionary,
        stock: SearchStock,
        sentimentStrength: Int,
        predictionDays: Int,
        sentimentData: [StockSentimentData],
        historicalData: [StockData],
        dataSet: DataSet) {
        self.date = date
        self.data = data
        self.stock = stock
        self.sentimentStrength = sentimentStrength
        self.predictionDays = predictionDays
        self.sentimentData = sentimentData
        self.historicalData = historicalData
        self.dataSet = dataSet
    }
}

extension Data {
    public var model: SVMModel? {
        do {
            if let object = try NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(self) as? NSDictionary {
                return SVMModel.init(load: object)
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
    
    public var asDataSet: DataSet? {
        do {
           if let object = try NSKeyedUnarchiver
               .unarchiveTopLevelObjectWithData(self) as? DataSet {
               return object
           }
        } catch let error {
           print("{CoreData} \(error)")
        }
        
        return nil
    }
}

extension StockModelObject {
    var asDetail: ConsoleDetailPayload? {
        guard let model = self.data?.model,
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
            model: .init(david: model))
    }
}
