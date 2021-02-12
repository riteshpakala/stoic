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
    
    public var history: String {
        coinGecko+"simple/price"
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
