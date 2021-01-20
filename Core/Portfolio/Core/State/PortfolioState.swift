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
public enum PortfolioStage: Equatable {
    case none
    case adding
}
public class PortfolioState: GraniteState {
    var type: PortfolioType
    var stage: PortfolioStage = .none
    
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
    
    var user: User {
        envDependency.user
    }
    
    var portfolio: Portfolio? {
        user.portfolio
    }
    
    var username: String {
        portfolio?.username ?? "unknown"
    }
}
