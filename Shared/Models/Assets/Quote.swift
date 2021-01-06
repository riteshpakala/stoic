//
//  Quote.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/5/21.
//


import Foundation

public struct Quote {
    var intervalType: SecurityInterval
    var ticker: String
    var securityType: SecurityType
    var exchangeName: String
    var securities: [Security]
}

