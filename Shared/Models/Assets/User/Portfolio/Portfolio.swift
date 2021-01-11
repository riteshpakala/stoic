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
    let floor: Floor
    
    public struct Holdings {
        let securities: [Security]
    }
    
    
    public init(_ username: String,
                _ holdings: Holdings,
                _ floor: Floor) {
        self.username = username
        self.holdings = holdings
        self.floor = floor
    }
}
