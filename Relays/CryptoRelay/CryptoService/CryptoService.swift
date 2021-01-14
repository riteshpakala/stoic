//
//  StockService.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//

import Foundation
import Combine

public class CryptoService {
    internal let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public enum Exchanges: String {
        case nasdaq
        case nyse
    }
    
    public func yahooV7(matching ticker: String, from pastEpoch: String, to futureEpoch: String) -> String {
        return "https://query1.finance.yahoo.com/v7/finance/download/\(ticker)?period1=\(pastEpoch)&period2=\(futureEpoch)&interval=1h&events=history"
    }
    
    public var quotes: String {
        coinGecko+"simple/price"
    }
    
    public var list: String {
        coinGecko+"coins/list"
    }
    
    public var coinGecko: String {
        return "https://api.coingecko.com/api/v3/"
    }
}

public struct CryptoServiceModels {
    
}
