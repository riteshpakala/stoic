import Foundation
import Granite

extension ServiceCenter {
    func getStockPredictions(from: CoreDataThread) -> [StockPredictionObject]? {
        switch from {
        case .background:
            return try? self.coreData.background.fetch(StockPredictionObject.fetchRequest())
        case .main:
            return try? self.coreData.main.fetch(StockPredictionObject.fetchRequest())
        }
    }
    
    func saveStockPredictions(_ prediction: StockPredictionObjectPre, with: CoreDataThread) {
        switch with {
        case .background:
            let bg = coreData.background
            let archiver: NSKeyedArchiver = .init(requiringSecureCoding: true)
            archiver.encode(prediction.data, forKey: "dict")
            archiver.finishEncoding()
            // This can archive the data
            // Encode it with archiver's encodedData retrieval
            // push it to CoreData
            // when retrieving
            // look at this for ref: https://stackoverflow.com/questions/22342439/save-nsdictionary-in-coredata
            // and then see if it works
            // we will have another idea again anyways.
            // but i think the key
            // is to use the date as the key
            // for the objects not a UUID.
            // and the date being the .last? of the prediction
            // session. I know you know what I mean.
            // and then the "last" prediction of that date
            // will be used to utilize a stale scenario.
            break
        case .main:
            let main = coreData.main
            break
        }
    }
}

public class StockPredictionObjectPre: NSObject {
    let date: String
    let data: NSDictionary
    
    public init(date: String, data: NSDictionary) {
        self.date = date
        self.data = data
    }
}
