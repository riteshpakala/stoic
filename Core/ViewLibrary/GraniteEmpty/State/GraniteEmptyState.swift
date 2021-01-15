//
//  GraniteEmptyState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/14/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class GraniteEmptyState: GraniteState {
    let text: String
    public init(_ text: String) {
        self.text = text
    }
    public required init() {
        text = ""
    }
}

public class GraniteEmptyCenter: GraniteCenter<GraniteEmptyState> {
    var gradients: [Color] {
        state.payload?.object as? [Color] ?? [Brand.Colors.marbleV2,
                                              Brand.Colors.marble]
    }
}
