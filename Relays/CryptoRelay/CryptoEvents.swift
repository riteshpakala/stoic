//
//  CryptoEvents.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/21/20.
//

import Foundation
import GraniteUI

struct CryptoEvents {
    public struct GetMovers: GraniteEvent {}
    
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
            .broadcast
        }
    }
}
