//
//  PortfolioState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum PortfolioType: Equatable, Hashable {
    case expanded
    case preview
    case holdings
    case unassigned
}
public class PortfolioState: GraniteState {
    var type: PortfolioType
    
    public init(_ type: PortfolioType = .expanded) {
        self.type = type
    }
    
    public required init() {
        self.type = .expanded
    }
}

public class PortfolioCenter: GraniteCenter<PortfolioState> {
    var envDependency: EnvironmentDependency {
        self.hosted.env
    }
}
