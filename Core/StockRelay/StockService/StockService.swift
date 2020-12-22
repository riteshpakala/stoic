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
                        
                        for i in 0..<stockData.count - 1 {
                            _ = stockData[i].update(
                                historicalTradingData: stockData.suffix(stockData.count - (i + 1)),
                                rsiMax: 20)
                        }
                        
                        return stockData
                    } else {
                        return nil
                    }
                
                }.eraseToAnyPublisher()
    }
}

public struct StockServiceModels {
    
}
