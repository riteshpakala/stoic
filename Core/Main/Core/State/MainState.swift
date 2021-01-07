//
//  MainState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class MainState: GraniteState {
    var count: Int = 0
}

public class MainCenter: GraniteCenter<MainState> {
    var routerDependency: RouterDependency {
        return dependency.hosted as? RouterDependency ?? .init(identifier: "none")
    }
}
