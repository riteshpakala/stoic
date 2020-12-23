//
//  StockService.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//

import Foundation
import Combine

public class StockService {
    internal let session: URLSession
    internal let decoder: JSONDecoder

    public init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    public func getStock(matching ticker: String, from pastEpoch: String, to futureEpoch: String) -> AnyPublisher<[StockData], URLError> {
        guard
            let urlComponents = URLComponents(string: "https://query1.finance.yahoo.com/v7/finance/download/\(ticker)?period1=\(pastEpoch)&period2=\(futureEpoch)&interval=1d&events=history")
            else { preconditionFailure("Can't create url components...") }

        guard
            let url = urlComponents.url
            else { preconditionFailure("Can't create url from url components...") }
        
        print("{TEST} \(url)")
        
        return session
                .dataTaskPublisher(for: url)
                .compactMap { (data, response) -> [StockData]? in
                    
                    if let content = String(data: data, encoding: .utf8),
                       let stockData = StockServiceUtilities.parseCSV(ticker: ticker, content: content) {
                        
                        guard stockData.count >= 60 else {
                            fatalError("Stock History should be more than 60 days in the past, so 30 day past indicators can be included")
                        }
                        
                        for i in 0..<max(stockData.count - 31, 1) {
                            _ = stockData[i].update(
                                historicalTradingData: Array(stockData[i + 1...i + 30]),
                                rsiMax: 20)
                        }
                        
                        return stockData.filter( { $0.dateData.asString != $0.lastStockData.dateData.asString } )
                    } else {
                        print(response)
                        return nil
                    }
                
                }.eraseToAnyPublisher()
    }
}

public struct StockServiceModels {
    
}
