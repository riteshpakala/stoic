//
//  Broadcasts.Movers.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/9/21.
//

import Foundation
import GraniteUI
import SwiftUI

public class BroadcastsMovers{
    public struct Categories {
        let topVolume: [Security]
        let winners: [Security]
        let losers: [Security]
        
        public init(_ topVolume: [Security] = [],
                    _ winners: [Security] = [],
                    _ losers: [Security] = []) {
            self.topVolume = topVolume
            self.winners = winners
            self.losers = losers
        }
    }
    
    var stocks: Categories = .init()
    var crypto: Categories = .init()
    
    public func updateStock(categories: Categories) {
        self.stocks = categories
    }
    
    public func updateCrypto(categories: Categories) {
        self.crypto = categories
    }
    
    public func get(_ securityType: SecurityType) -> Categories? {
        switch securityType {
        case .stock:
            return stocks
        case .crypto:
            return crypto
        default:
            return nil
        }
    }
}
