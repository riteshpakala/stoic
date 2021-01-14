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
    
    public struct SearchBackend: GraniteEvent {
        let query: String
        public init(_ query: String) {
            self.query = query
        }
    }
    
    public struct SearchDataResult: GraniteEvent {
        let query: String
        let data: [SearchResponse]
        
        public init(_ query: String, data: [SearchResponse]) {
            self.query = query
            self.data = data
        }
    }
    
    public struct GetSearchQuote: GraniteEvent {
        let data: [SearchResponse]
        
        public init(data: [SearchResponse]) {
            self.data = data
        }
    }
    
    public struct SearchResult: GraniteEvent {
        let result: [Security]
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
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
    
    //MARK: -- Crypto History
    public struct GetCryptoHistory: GraniteEvent {
        let security: Security
        let interval: SecurityInterval
        let daysAgo: Int
        
        public init(security: Security,
                    daysAgo: Int = 2400,
                    interval: SecurityInterval = .hour)//730 = 2 years - 1825 = 5 years
        {
            self.security = security
            self.interval = interval
            self.daysAgo = daysAgo
        }
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
    
    public struct History: GraniteEvent {
        let data: [CryptoCurrency]
        let interval: SecurityInterval
        
        public var beam: GraniteBeamType {
            .rebound
        }
    }
}
