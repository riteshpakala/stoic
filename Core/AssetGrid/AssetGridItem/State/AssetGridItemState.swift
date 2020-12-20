//
//  AssetGridItemState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class AssetGridItemState: GraniteState {
    var stockData: StockData {
        payload?.object as? StockData ?? .empty
    }
    
    
    var input: String = ""
}

public class AssetGridItemCenter: GraniteCenter<AssetGridItemState> {
    
}

