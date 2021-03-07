//
//  StockService.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//

import Foundation
import Combine
import GraniteUI

public class NetworkService {
    internal let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    
}

public struct NetworkServiceModels {
    
}

public protocol NetworkResponseData: Archiveable {
    var rawData: Data? { get set }
}

extension NetworkResponseData {
    public var rawData: Data? {
        get { nil }
        set {}
    }
}

extension Data {
    public func decodeNetwork<T: NetworkResponseData>(type: T.Type, decoder: JSONDecoder? = nil) -> T? {
        
        var result: T?
            do {
                try autoreleasepool {
                    result = try (decoder ?? JSONDecoder()).decode(T.self, from: self)
                }
            } catch let error {
                result = nil
                GraniteLogger.error("failed decoding:\n\(error.localizedDescription)\nself: \(String(describing: self))", .relay)
            }
        
        return result
    }
}
