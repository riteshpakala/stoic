//
//  CryptoEvents.swift
//  * stoic (iOS)
//
//  Created by Ritesh Pakala on 12/21/20.
//

import Foundation
import GraniteUI

struct CryptoEvents {
    public struct UpdateCategory: GraniteEvent {
        
    }
    
    public struct CategoryResult: GraniteEvent {
        let cryptocurrencies: [CryptoCurrency]
        
        public init(_ cryptocurrencies: [CryptoCurrency]) {
            self.cryptocurrencies = cryptocurrencies
        }
    }
}
