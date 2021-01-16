//
//  Portfolio.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//

import Foundation

public struct Portfolio {
    let username: String
    let holdings: Holdings
    let floors: [Floor]
    let strategies: [Strategy]
    
    public struct Holdings {
        let securityGroup: SecurityGroup
        
        var securities: [Security] {
            securityGroup.crypto + securityGroup.stocks
        }
        
        public init(_ securities: [Security]) {
            securityGroup = .init()
            securityGroup.crypto = securities.filter { $0.securityType == .crypto }
            securityGroup.stocks = securities.filter { $0.securityType == .stock }
        }
    }
    
    public init(_ username: String,
                _ holdings: Holdings,
                _ floors: [Floor],
                _ strategies: [Strategy]) {
        self.username = username
        self.holdings = holdings
        self.floors = floors
        self.strategies = strategies
    }
}
