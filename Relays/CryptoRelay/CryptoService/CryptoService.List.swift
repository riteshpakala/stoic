//
//  StockService.Search.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//

import Foundation
import Combine
import GraniteUI

extension CryptoService {
    public func getList() -> AnyPublisher<[SearchResponse], URLError> {
        guard
            let urlComponents = URLComponents(string: list)
            else { preconditionFailure("Can't create url components...") }

        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        GraniteLogger.info("searching crypto:\n\(url.absoluteString)\nself: \(String(describing: self))", .relay, focus: true)
        
        
        return session
                .dataTaskPublisher(for: url)
                .compactMap { (data, response) -> [SearchResponse]? in
                    autoreleasepool {
                        let decoder = JSONDecoder()
                        let listPayload: [CryptoServiceModels.List.Coin]?
                        do {
                            listPayload = try decoder.decode([CryptoServiceModels.List.Coin].self, from: data)
                        } catch let error {
                            listPayload = nil
                            GraniteLogger.error("failed decoding crypto coin\n\(error.localizedDescription)\nself: \(String(describing: self))", .relay)
                        }
                        
                        let response = listPayload?.compactMap {
                            SearchResponse.init(route: self.list,
                                                exchangeName: "crypto-generalized",
                                                entityDescription: $0.name,
                                                symbolName: $0.symbol,
                                                id: $0.id) }
                        
                        
                        return response
                    }
                    
                
                }.eraseToAnyPublisher()
    }
}

extension CryptoServiceModels {
    public struct List: Codable {
        
        public struct Coin: Codable {
            let id: String
            let symbol: String
            let name: String
        }
        
        let result: [Coin]
    }
}
