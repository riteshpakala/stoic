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
}

public class AssetAddCenter: GraniteCenter<AssetAddState> {
    var envDependency: EnvironmentDependency {
        dependency.hosted.env
    }
}
