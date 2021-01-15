//
//  GraniteDisclaimerState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/15/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class GraniteDisclaimerState: GraniteState {
    var colors: [Color]
    let text: String
    let opacity: Double
    public init(_ text: String,
                opacity: Double = 1.0,
                colors: [Color] = [Brand.Colors.marbleV2, Brand.Colors.marble]) {
        self.text = text
        self.colors = colors
        self.opacity = opacity
    }
    public required init() {
        text = ""
        self.colors = [Brand.Colors.marbleV2, Brand.Colors.marble]
        self.opacity = 1.0
    }
}

public class GraniteDisclaimerCenter: GraniteCenter<GraniteDisclaimerState> {
    var gradients: [Color] {
        state.payload?.object as? [Color] ?? state.colors
    }
}
