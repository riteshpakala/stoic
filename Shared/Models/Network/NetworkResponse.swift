//
//  NetworkResponse.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/13/21.
//

import Foundation
import CoreData

public protocol NetworkResponse {
    var route: String { get set }
    var responseType: NetworkResponseType { get }
}

public enum NetworkResponseType: String {
    case search
    case unassigned
}

extension NSManagedObjectContext {
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
