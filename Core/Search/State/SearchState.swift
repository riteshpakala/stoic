//
//  SearchState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class SearchState: GraniteState {
    var searchTimer: Timer? = nil
    var query: String = "" {
        didSet {
            print("{TEST} \(query)")
        }
    }
    
    var isEditing: Bool = false
    
    var securityType: SecurityType = .stock
    
    let context: WindowType
    
    public init(_ context: WindowType) {
        self.context = context
    }
    
    public required init() {
        self.context = .unassigned
    }
}

public class SearchCenter: GraniteCenter<SearchState> {
    let stockRelay: StockRelay = .init()
    let cryptoRelay: CryptoRelay = .init()
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            SearchSecurityExpedition.Discovery(),
            SearchStockResultExpedition.Discovery(),
            SearchCryptoResultExpedition.Discovery()
        ]
    }
}
