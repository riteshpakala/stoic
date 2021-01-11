//
//  GraniteButtonState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class GraniteButtonState: GraniteState {
    let text: String
    public init(_ text: String) {
        self.text = text
    }
    
    required init() {
        self.text = ""
    }
}

public class GraniteButtonCenter: GraniteCenter<GraniteButtonState> {
}
