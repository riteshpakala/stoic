//
//  NetworkResponse.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/13/21.
//

import Foundation
import CoreData
import GraniteUI

public protocol NetworkResponse {
    var route: String { get set }
    var responseType: NetworkResponseType { get }
}

public struct BaseNetworkResponse: NetworkResponse {
    public var route: String
    public var responseType: NetworkResponseType
    public var data: Data?
}

extension NetworkResponseObject {
    var asNetworkResponse: BaseNetworkResponse {
        return .init(route: self.route, responseType: NetworkResponseType.init(rawValue: self.responseType) ?? .unassigned, data: self.data)
    }
}

public enum NetworkResponseType: String {
    case search
    case movers
    case unassigned
}

extension NSManagedObjectContext {
    public func save(route: String,
                     data: Data,
                     responseType: NetworkResponseType) {
        self.performAndWait {
            let object = BaseNetworkResponseObject.init(context: self)
            object.date = .today
            object.data = data
            object.responseType = responseType.rawValue
            object.route = route
            
            do {
                try self.save()
            } catch let error {
                GraniteLogger.info("failed to save network object for \(responseType)\n\(error) - self: \(String(describing: self))", .utility, focus: true)
            }
        }
    }
    public func networkResponseExists(forRoute route: String,
                                             _ completion: @escaping((NetworkResponseType?) -> Void)) {
        
        let request: NSFetchRequest = NetworkResponseObject.fetchRequest()
        request.predicate = NSPredicate(format: "(route == %@)",
                                        route)
        
        
        self.performAndWait {
            if let object = try? self.fetch(request).first {
                completion(NetworkResponseType.init(rawValue: object.responseType))
            } else {
                completion(nil)
            }
        }
    }
    
    public func networkResponse(forRoute route: String,
                                             _ completion: @escaping((BaseNetworkResponse?) -> Void)) {
        
        let request: NSFetchRequest = BaseNetworkResponseObject.fetchRequest()
        request.predicate = NSPredicate(format: "(route == %@)",
                                        route)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        self.performAndWait {
            completion(try? self.fetch(request).first?.asNetworkResponse)
        }
    }
    
    public func checkSearchCache(forRoute route: String,
                                 _ completion: @escaping(([SearchResponse]?) -> Void)) {
        
        let request: NSFetchRequest = SearchResponseObject.fetchRequest()
        request.predicate = NSPredicate(format: "(route == %@)",
                                        route)
        
        self.networkResponseExists(forRoute: route) { type in
            switch type {
            case .search:
                self.performAndWait {
                    if let objects = try? self.fetch(request) {
                        completion(objects.map { $0.asSearchResponse })
                    }
                }
            default:
                completion(nil)
                break
            }
        }
    }
}
