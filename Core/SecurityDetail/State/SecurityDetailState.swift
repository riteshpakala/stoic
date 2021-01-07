//
//  SecurityDetailState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum SecurityDetailType {
    case expanded
    case preview
}
public class SecurityDetailState: GraniteState {
    let kind: SecurityDetailType
    
    public init(_ kind: SecurityDetailType) {
        self.kind = kind
    }
    
    public required init() {
        self.kind = .preview
    }
}

public class SecurityDetailCenter: GraniteCenter<SecurityDetailState> {
}
