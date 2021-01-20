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
    
    public func stageForDetail(_ security: Security) -> SecurityDetailStage? {
        if let index = floors.firstIndex(where: { $0.security?.assetID == security.assetID }) {
            return floors[index].detail.stage
        } else {
            return nil
        }
    }
    
    public func updateDetailStage(_ security: Security, stage: SecurityDetailStage) {
        if let index = floors.firstIndex(where: { $0.security?.assetID == security.assetID }) {
            floors[index].detail.stage = stage
        }
    }
    
    public func updateDetailQuote(_ security: Security, quote: Quote?) {
        if let index = floors.firstIndex(where: { $0.security?.assetID == security.assetID }) {
            floors[index].detail.quote = quote
        }
    }
}
