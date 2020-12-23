//
//  DataHandling.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/23/20.
//

import Foundation

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

open class Archiveable: Codable {}
extension Archiveable {
    public var archived: Data? {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch let error {
            print("{CoreData} \(error.localizedDescription)")
            return nil
        }
    }
}

extension Data {
    public var asStockData: StockData? {
        do {
           if let object = try NSKeyedUnarchiver
               .unarchiveTopLevelObjectWithData(self) as? StockData {
               return object
           }
        } catch let error {
           print("{CoreData} \(error)")
        }

        return nil
    }
}

//extension Data {
//    public var model: StockKitModels? {
//        let jsonDecoder: JSONDecoder = .init()
//        do {
//            return try jsonDecoder.decode(StockKitModels.self, from: self)
//        } catch let error {
//            print("{CoreData} \(error)")
//        }
//        
//        return nil
//    }
//    
//    public var asStockData: [StockData]? {
//        do {
//           if let object = try NSKeyedUnarchiver
//               .unarchiveTopLevelObjectWithData(self) as? [StockData] {
//               return object
//           }
//        } catch let error {
//           print("{CoreData} \(error)")
//        }
//        
//        return nil
//    }
//    
//    public var asStockSentimentData: [StockSentimentData]? {
//        do {
//           if let object = try NSKeyedUnarchiver
//               .unarchiveTopLevelObjectWithData(self) as? [StockSentimentData] {
//               return object
//           }
//        } catch let error {
//           print("{CoreData} \(error)")
//        }
//        
//        return nil
//    }
//    
//    public var asSearchStock: SearchStock? {
//        do {
//           if let object = try NSKeyedUnarchiver
//               .unarchiveTopLevelObjectWithData(self) as? SearchStock {
//               return object
//           }
//        } catch let error {
//           print("{CoreData} \(error)")
//        }
//        
//        return nil
//    }
//    
//    public var mergedModelIDs: [String]? {
//        return (try? JSONDecoder().decode([String].self, from: self))
//    }
//}
