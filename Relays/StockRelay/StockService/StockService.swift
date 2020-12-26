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
    
    public func yahooV7(matching ticker: String, from pastEpoch: String, to futureEpoch: String) -> String {
        return "https://query1.finance.yahoo.com/v7/finance/download/\(ticker)?period1=\(pastEpoch)&period2=\(futureEpoch)&interval=1h&events=history"
    }
    
    public func yahooV8Recent(matching ticker: String) -> String {
        return "https://query1.finance.yahoo.com/v8/finance/chart/\(ticker)?region=US&lang=en-US&includePrePost=true&interval=1h&range=\("120d")&corsDomain=finance.yahoo.com&.tsrc=finance"
    }
    
    public func yahooV8(matching ticker: String, from pastEpoch: String, to futureEpoch: String, interval: SecurityInterval) -> String {
        return "https://query1.finance.yahoo.com/v8/finance/chart/\(ticker)?period1=\(pastEpoch)&period2=\(futureEpoch)&region=US&lang=en-US&includePrePost=true&interval=\(interval.rawValue)&corsDomain=finance.yahoo.com&.tsrc=finance"
    }

    
}

public struct StockServiceModels {
    
}
