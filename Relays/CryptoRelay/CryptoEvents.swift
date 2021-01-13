//
//  CryptoEvents.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/21/20.
//

import Foundation
import GraniteUI

struct CryptoEvents {
    public struct Search: GraniteEvent {
        let query: String
        public init(_ query: String) {
            self.query = query
        }
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
//    public struct SearchDataResult: GraniteEvent {
//        let data: [StockServiceModels.Search]
//    }
//    
//    public struct SearchQuoteResults: GraniteEvent {
//        let quotes: [StockServiceModels.Quotes]
//    }
    
    public struct GetMovers: GraniteEvent {
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
    public struct GlobalCategoryResult: GraniteEvent {
        let losers: [CryptoCurrency]
        let gainers: [CryptoCurrency]
        let topVolume: [CryptoCurrency]

        public init(_ topVolume: [CryptoCurrency],
                    _ gainers: [CryptoCurrency],
                    _ losers: [CryptoCurrency]) {
            self.topVolume = topVolume
            self.gainers = gainers
            self.losers = losers
        }
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
    //MARK: -- Stock History
    public struct GetCryptoHistory: GraniteEvent {
        let ticker: String
        let daysAgo: Int
        
        public init(ticker: String, daysAgo: Int = 2400)//730 = 2 years - 1825 = 5 years
        {
            self.ticker = ticker
            self.daysAgo = daysAgo
        }
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
}
