//
//  SearchState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

public class SearchStock: NSObject, Codable {
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
}

public enum SearchStockKeys: String {
    case countryCode = "countryCode"
    case issueType = "issueType"
    case symbolName = "symbolName"
    case companyName = "companyName"
    case exchangeName = "exchangeName"
}

public class SearchState: State {
    @objc dynamic var searchTimer: Timer? = nil
    let searchDelay: TimeInterval = 1.2
    
    let validCountryCode: String = "US"
    let validIssueType: String = "STOCK"
    
    @objc dynamic var stocks: Array<SearchStock> = []
    @objc dynamic var stockRotation: Array<SearchStock> = []
    @objc dynamic var stockResultsActive: Bool = false
}
