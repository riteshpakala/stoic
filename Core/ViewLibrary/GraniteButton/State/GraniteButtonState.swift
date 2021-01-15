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

public enum GraniteButtonType {
    case text(String)
    case image(String)
}

public class GraniteButtonState: GraniteState {
    let type: GraniteButtonType
    let selected: Bool
    let padding: EdgeInsets
    let size: CGSize
    let selectionColor: Color
    
    public init(_ text: String) {
        self.type = .text(text)
        self.selected = false
        self.size = .zero
        self.selectionColor = .black
        self.padding = .init(Brand.Padding.large,
                             Brand.Padding.medium,
                             Brand.Padding.large,
                             Brand.Padding.medium)
    }
    
    public init(_ type: GraniteButtonType,
                selected: Bool = false,
                size: CGSize = .zero,
                selectionColor: Color = .black,
                padding: EdgeInsets = .init(0, 0, 0, 0)) {
        self.type = type
        self.size = size
        self.selectionColor = selectionColor
        self.selected = selected
        self.padding = padding
    }
    
    required init() {
        type = .text("")
        self.selected = false
        self.size = .zero
        self.selectionColor = .black
        self.padding = .init(Brand.Padding.large,
                             Brand.Padding.medium,
                             Brand.Padding.large,
                             Brand.Padding.medium)
    }
}

public class GraniteButtonCenter: GraniteCenter<GraniteButtonState> {
}
