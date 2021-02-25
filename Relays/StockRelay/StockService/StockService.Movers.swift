//
//  StockService.Quotes.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//

import Foundation
import Combine
import GraniteUI

extension StockService {
    public func getMovers(count: Int = 12) -> AnyPublisher<NetworkResponseData?, URLError> {
        guard
            var urlComponents = URLComponents(string: movers)
            else { preconditionFailure("Can't create url components...") }
        
        let regionQuery: URLQueryItem = .init(name: "region", value: "US")
        let langQuery: URLQueryItem = .init(name: "lang", value: "en-US")
        let startQuery: URLQueryItem = .init(name: "start", value: "0")
        let countQuery: URLQueryItem = .init(name: "count", value: "\(count)")
        
        urlComponents.queryItems = [regionQuery, langQuery, startQuery, countQuery]
        
        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        GraniteLogger.info("fetching stock movers:\n\(url.absoluteString)\nself: \(String(describing: self))", .relay, focus: true)
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        let headers = [
            "x-rapidapi-key": "2a224e70a9msh9e0e2e3a2a20673p19f962jsn59435ee9b515",
            "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
        ]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let decoder = JSONDecoder()
        return session
                .dataTaskPublisher(for: request)
                .compactMap { (data, response) -> NetworkResponseData? in
                    
                    let movers: StockServiceModels.Movers? = data.decodeNetwork(type: StockServiceModels.Movers.self, decoder: decoder)
                    return movers
                
                }.eraseToAnyPublisher()
    }
    
    public func getMoversFromStoic() -> AnyPublisher<NetworkResponseData?, URLError> {
        guard
            var urlComponents = URLComponents(string: "https://yqqa677w92.execute-api.us-west-1.amazonaws.com/default/stoic-movers")
            else { preconditionFailure("Can't create url components...") }
        
        let tableQuery: URLQueryItem = .init(name: "TableName", value: "stoic-stock-movers")
        let pageQuery: URLQueryItem = .init(name: "pageid", value: Date.today.asString)
        
        urlComponents.queryItems = [tableQuery, pageQuery]
        
        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        GraniteLogger.info("getting movers from stoic \n\(url.absoluteString)\nself: \(String(describing: self))", .relay, focus: true)
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        let headers = [
            "x-api-key": "2jzhkSc60N3LOdpI9J0NW5J6MnHbedFU2ypEJvcX"
        ]
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let decoder = JSONDecoder()
        return session
                .dataTaskPublisher(for: request)
                .compactMap { (data, response) -> NetworkResponseData? in
                    let movers: StockServiceModels.MoversStoic?
                    do {
                        
                        movers = try decoder.decode(StockServiceModels.MoversStoic.self, from: data)
                    } catch let error {
                        movers = nil
                        GraniteLogger.info("failed fetching movers from Stoic:\n\(error)\nself: \(String(describing: self))", .relay, focus: true)
                    }
                    return movers
                }.eraseToAnyPublisher()
    }
    
    public func sendMovers(data: [String: Any]) -> AnyPublisher<Bool, URLError> {
        guard
            let urlComponents = URLComponents(string: "https://yqqa677w92.execute-api.us-west-1.amazonaws.com/default/stoic-movers")
            else { preconditionFailure("Can't create url components...") }
        
        let createdDate: Int = Date.today.timeIntervalSince1970.asInt
        let json: [String: Any] = ["TableName": "stoic-stock-movers",
                                   "Item": [ "pageid": Date.today.asString, "date": createdDate, "data": data ]]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        GraniteLogger.info("sending movers \nself: \(String(describing: self))", .relay, focus: true)
        
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        let headers = [
            "x-api-key": "2jzhkSc60N3LOdpI9J0NW5J6MnHbedFU2ypEJvcX"
        ]
        
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = jsonData
        
        return session
                .dataTaskPublisher(for: request)
                .compactMap { (data, response) -> Bool in
                    return true
                }.eraseToAnyPublisher()
    }
}

extension StockServiceModels {
    public struct Movers: NetworkResponseData {
        let finance: Finance
    }
    
    public struct MoversStoic: NetworkResponseData {
        struct Item: Codable {
            let pageid: String
            let date: Int
            let data: StockServiceModels.Movers
        }
        let Items: [Item]
    }
    
    public struct MoversArchiveable: NetworkResponseData {
        var movers: StockServiceModels.Movers?
        var quotes: [StockServiceModels.Quotes]
        
        public init(_ movers: StockServiceModels.Movers? = nil,
                    _ quotes: [StockServiceModels.Quotes] = []) {
            self.movers = movers
            self.quotes = quotes
        }
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
            let firstTradeDateMilliseconds: Int64?
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
