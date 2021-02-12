//
//  RouterState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class RouterState: GraniteState {
}

public class RouterCenter: GraniteCenter<RouterState> {
    lazy var routerDependency: RouterDependency = {
        .init(Router.init())
    }()
}
