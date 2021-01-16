//
//  WindowState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class WindowState: GraniteState {
    let config: WindowConfig
    
    public init(_ config: WindowConfig) {
        self.config = config
    }
    
    required init() {
        self.config = .none
    }
}

public class WindowCenter: GraniteCenter<WindowState> {
    var envDependency: EnvironmentDependency {
        self.hosted.env
    }
    
    public override var loggerSymbol: String {
        "🪟"
    }
}
