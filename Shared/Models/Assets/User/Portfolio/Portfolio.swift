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
    
    public struct Holdings {
        let securities: [Security]
    }
    
    
    public init(_ username: String,
                _ holdings: Holdings) {
        self.username = username
        self.holdings = holdings
    }
}
