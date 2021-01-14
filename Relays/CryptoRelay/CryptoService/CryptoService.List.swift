//
//  StockService.Search.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//

import Foundation
import Combine

extension CryptoService {
    public func getList() -> AnyPublisher<[SearchResponse], URLError> {
        guard
            let urlComponents = URLComponents(string: list)
            else { preconditionFailure("Can't create url components...") }

        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        let decoder = JSONDecoder()
        
        return session
                .dataTaskPublisher(for: url)
                .compactMap { (data, response) -> [SearchResponse]? in
                    
                    let listPayload: [CryptoServiceModels.List.Coin]?
                    do {
                        listPayload = try decoder.decode([CryptoServiceModels.List.Coin].self, from: data)
                    } catch let error {
                        listPayload = nil
                        print("{TEST} \(error)")
                    }
                    
                    let response = listPayload?.compactMap {
                        SearchResponse.init(route: self.list,
                                            exchangeName: "crypto-generalized",
                                            entityDescription: $0.name,
                                            symbolName: $0.symbol,
                                            id: $0.id) }
                    
                    
                    return response
                    
                
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
