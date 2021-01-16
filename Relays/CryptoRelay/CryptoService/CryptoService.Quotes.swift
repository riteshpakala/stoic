//
//  StockService.Movers.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//

import Foundation
import Combine
import GraniteUI

extension CryptoService {
    public func getQuotes(symbols: String) -> AnyPublisher<[CryptoServiceModels.Quotes.Coin], URLError> {
        guard
            var urlComponents = URLComponents(string: quotes)
            else { preconditionFailure("Can't create url components...") }
        
        let symbolsQuery: URLQueryItem = .init(name: "ids", value: symbols)
        let vsCurrencyQuery: URLQueryItem = .init(name: "vs_currencies", value: "usd")
        let marketCap24hQuery: URLQueryItem = .init(name: "include_market_cap", value: "true")
        let vol24hQuery: URLQueryItem = .init(name: "include_24hr_vol", value: "true")
        let change24hQuery: URLQueryItem = .init(name: "include_24hr_change", value: "true")
        let lastUpdated: URLQueryItem = .init(name: "include_last_updated_at", value: "true")
        
        urlComponents.queryItems = [symbolsQuery,
                                    vsCurrencyQuery,
                                    marketCap24hQuery,
                                    vol24hQuery,
                                    change24hQuery,
                                    lastUpdated]
        
        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        GraniteLogger.info("fetching crypto quotes:\n\(url.absoluteString)\nself: \(self)", .relay)
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        
        let decoder = JSONDecoder()
        return session
                .dataTaskPublisher(for: request)
                .compactMap { (data, response) -> [CryptoServiceModels.Quotes.Coin]? in
                    
                    let response: [String:[String:Double?]]?
                    do {
                        
                        response = try decoder.decode([String:[String:Double?]].self, from: data)
                    } catch let error {
                        response = nil
                        GraniteLogger.error("failed fetching crypto quotes:\n\(error.localizedDescription)\nself: \(self)", .relay)
                    }
                    
                    
                    guard let result = response else {
                        return nil
                    }
                    
                    var coins: [CryptoServiceModels.Quotes.Coin] = []
                    for key in result.keys {
                        
                        if let values = result[key] {
                            if let price = values[CryptoServiceModels.Quotes.Keys.price.rawValue] as? Double,
                               let marketCap = values[CryptoServiceModels.Quotes.Keys.marketCap.rawValue] as? Double,
                               let volume = values[CryptoServiceModels.Quotes.Keys.volume.rawValue] as? Double,
                               let change = values[CryptoServiceModels.Quotes.Keys.change.rawValue] as? Double,
                               let updatedAt = values[CryptoServiceModels.Quotes.Keys.updatedAt.rawValue] as? Double {
                                
                                
                                
                                coins.append(.init(price: price,
                                                   marketCap: marketCap,
                                                   volume24H: volume,
                                                   change24h: change,
                                                   lastUpdatedAt: updatedAt,
                                                   currencyVS: "usd",
                                                   name: key))
                                
                            }
                        }
                    }
                    
                    return coins
                
                }.eraseToAnyPublisher()
    }
}

extension CryptoServiceModels {
    public struct Quotes: Codable {
        public enum Keys: String {
            case price = "usd"
            case marketCap = "usd_market_cap"
            case volume = "usd_24h_vol"
            case change = "usd_24h_change"
            case updatedAt = "last_updated_at"
        }
        
        public struct Coin: Codable {
            let price: Double
            let marketCap: Double
            let volume24H: Double
            let change24h: Double
            let lastUpdatedAt: Double
            let currencyVS: String
            let name: String
        }
//        bitcoin": {
//            "usd": 36094,
//            "usd_market_cap": 671272663036.5874,
//            "usd_24h_vol": 62699503943.43388,
//            "usd_24h_change": 4.290001849727924,
//            "last_updated_at": 1610568236
//          }
        
        let result: [Coin]
    }
}
