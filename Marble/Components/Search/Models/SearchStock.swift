//
//  SearchStock.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/6/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public class SearchStock: NSObject, Codable, NSCoding, NSSecureCoding {
    public static var supportsSecureCoding: Bool = true
    var exchangeName: String?
    var symbolName: String?
    var companyName: String?
    
    var symbol: String {
        return "$"+(symbolName ?? "")
    }
    
    init(
        exchangeName: String?,
        symbolName: String?,
        companyName: String?){
        
        self.exchangeName = exchangeName
        self.symbolName = symbolName
        self.companyName = companyName
        
        super.init()
    }
    
    public required convenience init?(coder: NSCoder) {
        let exchangeName = coder.decodeObject(forKey: "exchangeName") as? String
        let symbolName = coder.decodeObject(forKey: "symbolName") as? String
        let companyName = coder.decodeObject(forKey: "companyName") as? String

        self.init(
            exchangeName: exchangeName,
            symbolName: symbolName,
            companyName: companyName)
    }

    public func encode(with coder: NSCoder){
        coder.encode(exchangeName, forKey: "exchangeName")
        coder.encode(symbolName, forKey: "symbolName")
        coder.encode(companyName, forKey: "companyName")
    }
    
    static var zero: SearchStock {
        return SearchStock.init(exchangeName: nil, symbolName: nil, companyName: nil)
    }
}

