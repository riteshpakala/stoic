//
//  AssetAddState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/8/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class AssetAddState: GraniteState {
    var context: WindowType
    var searchState: SearchQuery
    public init(_ searchState: SearchQuery) {
        self.searchState = searchState
        self.context = searchState.state.context
    }
    
    public required init() {
        self.searchState = .init(.init(.portfolio))
        self.context = .portfolio
    }
}

public class AssetAddCenter: GraniteCenter<AssetAddState> {
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
}
