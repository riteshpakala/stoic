//
//  SearchComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import UIKit

public class SearchComponent: Component<SearchState> {
    override var reducers: [AnyReducer] {
        [
            GetSearchResultsReducer.Reducible(),
            GetSearchResultsResponseReducer.Reducible()
        ]
    }
    
    override func didLoad() {
        push(
            StockKitBuilder.build(
                self.services,
                parent: self))
    }
}
