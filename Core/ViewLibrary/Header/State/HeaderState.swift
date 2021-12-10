//
//  HeaderState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/2/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class HeaderState: GraniteState {
    let title: String
    
    public init(_ title: String) {
        self.title = title
    }
    
    public required init() {
        self.title = "no title"
    }
}

public class HeaderCenter: GraniteCenter<HeaderState> {
}
