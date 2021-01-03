//
//  StockService.Search.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//

import Foundation
import Combine

extension StockService {
    public func search(matching ticker: String) -> AnyPublisher<[StockServiceModels.Search], URLError> {
        guard
            let urlComponents = URLComponents(string: cnbcSearch(matching: ticker))
            else { preconditionFailure("Can't create url components...") }

        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        print("{TEST} \(url)")
        
        let decoder = JSONDecoder()
        
        return session
                .dataTaskPublisher(for: url)
                .compactMap { (data, response) -> [StockServiceModels.Search]? in
                    
                    let chart: [[String:String]]?
                    do {
                        chart = try decoder.decode([[String:String]].self, from: data)
                    } catch let error {
                        chart = nil
                        print("{TEST} \(error)")
                    }
                    
                    return chart != nil ? [StockServiceModels.Search.init(data: chart!)] : nil
                    
                
                }.eraseToAnyPublisher()
    }
}

extension StockServiceModels {
    public struct Search: Codable {
        public enum Keys: String {
            case countryCode = "countryCode"
            case issueType = "issueType"
            case symbolName = "symbolName"
            case companyName = "companyName"
            case exchangeName = "exchangeName"
        }
        
        let data: [[String: String]]
        
        public struct Stock {
            let exchangeName: String
            let symbolName: String
            let companyName: String
        }
    }
}
