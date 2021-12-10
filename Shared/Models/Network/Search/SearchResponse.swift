//
//  SearchResponse.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/13/21.
//

import Foundation
import CoreData
import GraniteUI

public struct SearchResponse: NetworkResponse {
    public var route: String
    public var exchangeName: String
    public var entityDescription: String
    public var symbolName: String
    public var id: String?
}

extension SearchResponse {
    public var responseType: NetworkResponseType {
        .search
    }
}

extension SearchResponse {
    func save(moc: NSManagedObjectContext) {
        moc.performAndWait {
            let object: SearchResponseObject = .init(context: moc)
            self.apply(to: object)
            
            do {
                try moc.save()
            } catch let error {
                GraniteLogger.error("failed to save search response\n\(error.localizedDescription)", .utility)
            }
        }
    }
    
    func apply(to srObject: SearchResponseObject) {
        srObject.route = self.route
        srObject.exchangeName = self.exchangeName
        srObject.entityDescription = self.entityDescription
        srObject.symbolName = self.symbolName
        srObject.responseType = self.responseType.rawValue
        srObject.id = self.id
        srObject.date = .today
    }
}

extension SearchResponseObject {
    var asSearchResponse: SearchResponse {
        .init(route: self.route,
              exchangeName: self.exchangeName,
              entityDescription: self.entityDescription,
              symbolName: self.symbolName,
              id: self.id)
    }
}

extension CryptoServiceModels.Asset {
    func asResponse(_ exchange: String,
                    route: String) -> SearchResponse {
        let exchangeName = exchange
        let entity = self.name
        let symbol = self.symbol
        
        return .init(route: route,
                     exchangeName: exchangeName,
                     entityDescription: entity,
                     symbolName: symbol,
                     id: "")
        
    }
}
