//
//  StockService.Quotes.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//

import Foundation
import Combine

extension StockService {
    public func getMovers(count: Int = 5) -> AnyPublisher<[StockServiceModels.Movers], URLError> {
        guard
            var urlComponents = URLComponents(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/market/v2/get-movers")
            else { preconditionFailure("Can't create url components...") }
        
        let regionQuery: URLQueryItem = .init(name: "region", value: "US")
        let langQuery: URLQueryItem = .init(name: "lang", value: "en-US")
        let startQuery: URLQueryItem = .init(name: "start", value: "0")
        let countQuery: URLQueryItem = .init(name: "count", value: "\(count)")
        
        urlComponents.queryItems = [regionQuery, langQuery, startQuery, countQuery]
        
        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        print("{TEST} \(url)")
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        let headers = [
            "x-rapidapi-key": "0c0e4882d8mshff3f1b457562c64p12c681jsn48b2eeb37946",
            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
        ]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let decoder = JSONDecoder()
        return session
                .dataTaskPublisher(for: request)
                .compactMap { (data, response) -> [StockServiceModels.Movers]? in
                    
                    let movers: StockServiceModels.Movers?
                    do {
                        
                        movers = try decoder.decode(StockServiceModels.Movers.self, from: data)
                    } catch let error {
                        movers = nil
                        print("{TEST} \(error)")
                    }
                    
                    return movers != nil ? [movers!] : nil
                
                }.eraseToAnyPublisher()
    }
}

extension StockServiceModels {
    public struct Movers: Codable {
        let finance: Finance
    }
    
    public struct Finance: Codable {
        public struct MoversResult: Codable {
            let id: String
            let title: String
            let description: String
            let canonicalName: String
            let criteriaMeta: CriteriaMeta
            let rawCriteria: String
            let start: Int
            let count: Int
            let total: Int
            let quotes: [Quote]
            let predefinedScr: Bool
            let versionId: Int
        }
        
        public struct CriteriaMeta: Codable {
            let size: Int
            let offset: Int
            let sortField: String
            let sortType: String
            let quoteType: String
            let topOperator: String
            let criteria: [Criteria]
        }
        
        public struct Criteria: Codable {
            let field: String
            
            let operators: [String]
            let values: [Double]
            let labelsSelected: [Int]
        }
        
        public struct Quote: Codable {
            let language: String
            let region: String
            let quoteType: String
            let quoteSourceName: String
            let triggerable: Bool
            let sourceInterval: Int32
            let exchangeDataDelayedBy: Int32
            let exchangeTimezoneName: String
            let exchangeTimezoneShortName: String
            let gmtOffSetMilliseconds: Int32
            let esgPopulated: Bool
            let tradeable: Bool
            let firstTradeDateMilliseconds: Int64
            let priceHint: Int64
            let exchange: String
            let market: String
            let fullExchangeName: String
            let marketState: String
            let symbol: String
        }
        
        let result: [MoversResult]
        let error: String?
    }
}
