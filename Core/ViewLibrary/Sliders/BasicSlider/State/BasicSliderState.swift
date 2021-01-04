//
//  BasicSliderState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class BasicSliderState: GraniteState {
    var number: Double = 0.25
}

public class BasicSliderCenter: GraniteCenter<BasicSliderState> {
}
