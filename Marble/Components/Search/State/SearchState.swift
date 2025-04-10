//
//  SearchState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

public enum SearchStockKeys: String {
    case countryCode = "countryCode"
    case issueType = "issueType"
    case symbolName = "symbolName"
    case companyName = "companyName"
    case exchangeName = "exchangeName"
}

public class SearchState: State {
    @objc dynamic var searchTimer: Timer? = nil
    let searchDelay: TimeInterval
    
    let validCountryCode: String = "US"
    let validIssueType: String = "STOCK"
    
    @objc dynamic var stocks: Array<SearchStock> = []
    @objc dynamic var stockRotation: Array<SearchStock> = []
    @objc dynamic var stockResultsActive: Bool = false
    @objc dynamic var subscription: Int = GlobalDefaults.Subscription.none.rawValue
    @objc dynamic var isLoadingRotation: Bool = false
    
    override init() {
        searchDelay = 1.0.randomBetween(2.4)
        super.init()
    }
}
