//
//  StockSearchData.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

public struct StockSearchPayload {
    public let ticker: String
    public let companyHashtag: String
    public let companyName: String
    public let symbolHashtag: String
    public let symbolName: String
    
    public init(
        ticker: String,
        companyHashtag: String,
        companyName: String,
        symbolHashtag: String,
        symbolName: String) {
        
        self.ticker = ticker
        self.companyHashtag = companyHashtag
        self.companyName = companyName
        self.symbolHashtag = symbolHashtag
        self.symbolName = symbolName
    }
    
    func cycle(_ move: Int) -> String {
        let count = asArray.count
        
        if move%count < count {
            return self.asArray[move%count]
        } else {
            return ticker
        }
    }
    
    var asString: String {
        "\(ticker), \(companyHashtag), \(companyName), \(symbolHashtag), \(symbolName)"
    }
    
    var asArray: [String] {
        //Removed ticker option, twitter is blocking the `$` op usage
        [symbolName, companyHashtag, companyName, symbolHashtag, symbolName]
    }
}
