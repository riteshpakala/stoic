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
    public var date: Date
}

extension NetworkResponseObject {
    var asNetworkResponse: BaseNetworkResponse {
        return .init(route: self.route,
                     responseType: NetworkResponseType.init(rawValue: self.responseType) ?? .unassigned,
                     data: self.data,
                     date: self.date)
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
        self.performAndWait { [weak self] in
            guard let this = self else { return }
            let object = BaseNetworkResponseObject.init(context: this)
            object.date = .today
            object.data = data
            object.responseType = responseType.rawValue
            object.route = route
            
            do {
                try self?.save()
            } catch let error {
                GraniteLogger.info("failed to save network object for \(responseType)\n\(error) - self: \(String(describing: self))", .utility, focus: true)
            }
        }
    }
    public func networkResponseExists(forRoute route: String) -> NetworkResponseType? {
        
        let request: NSFetchRequest = NetworkResponseObject.fetchRequest()
        request.predicate = NSPredicate(format: "(route == %@)",
                                        route)
        
        
        let result: NetworkResponseType? = self.performAndWaitPlease { [weak self] in
            do {
                if let object = try self?.fetch(request).first {
                    return NetworkResponseType.init(rawValue: object.responseType)
                } else {
                    return nil
                }
            } catch let error {
                return nil
            }
        }
        
        return result
    }
    
    public func networkResponse(forRoute route: String) -> BaseNetworkResponse? {
        
        let request: NSFetchRequest = BaseNetworkResponseObject.fetchRequest()
        request.predicate = NSPredicate(format: "(route == %@)",
                                        route)
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        
        let result = self.performAndWaitPlease { [weak self] in
            return (try? self?.fetch(request).first?.asNetworkResponse)
        }
        
        return result
    }
    
    public func checkSearchCache(forRoute route: String) -> [SearchResponse]? {
        
        let request: NSFetchRequest = SearchResponseObject.fetchRequest()
        request.predicate = NSPredicate(format: "(route == %@)",
                                        route)
        
        let type = networkResponseExists(forRoute: route)
        
        switch type {
        case .search:
            let result: [SearchResponse]? = self.performAndWaitPlease { [weak self] in
                do {
                    if let objects = try self?.fetch(request) {
                        return objects.map { $0.asSearchResponse }
                    } else {
                        return nil
                    }
                } catch let error {
                    return nil
                }
            }
            return result
        default:
            return nil
        }
    }
}
extension NSManagedObjectContext {
    func performAndWaitPlease<T>(_ block: () throws -> T) rethrows -> T {
        return try _performAndWaitHelper(
            fn: performAndWait, execute: block, rescue: { throw $0 }
        )
    }

    /// Helper function for convincing the type checker that
    /// the rethrows invariant holds for performAndWait.
    ///
    /// Source: https://github.com/apple/swift/blob/bb157a070ec6534e4b534456d208b03adc07704b/stdlib/public/SDK/Dispatch/Queue.swift#L228-L249
    private func _performAndWaitHelper<T>(
        fn: (() -> Void) -> Void,
        execute work: () throws -> T,
        rescue: ((Error) throws -> (T))) rethrows -> T
    {
        var result: T?
        var error: Error?
        withoutActuallyEscaping(work) { _work in
            fn {
                do {
                    result = try _work()
                } catch let e {
                    error = e
                }
            }
        }
        if let e = error {
            return try rescue(e)
        } else {
            return result!
        }
    }
}
