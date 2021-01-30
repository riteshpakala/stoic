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
    case add
    case addNoSeperator
}

public class GraniteButtonState: GraniteState {
    let type: GraniteButtonType
    let selected: Bool
    let padding: EdgeInsets
    let size: CGSize
    let selectionColor: Color
    let action: (() -> Void)?
    
    public init(_ text: String,
                action: (() -> Void)? = nil) {
        self.type = .text(text)
        self.selected = false
        self.size = .zero
        self.selectionColor = .black
        self.padding = .init(Brand.Padding.large,
                             Brand.Padding.medium,
                             Brand.Padding.large,
                             Brand.Padding.medium)
        self.action = action
    }
    
    public init(_ type: GraniteButtonType,
                selected: Bool = false,
                size: CGSize = .zero,
                selectionColor: Color = .black,
                padding: EdgeInsets = .init(0, 0, 0, 0),
                action: (() -> Void)? = nil) {
        self.type = type
        self.size = size
        self.selectionColor = selectionColor
        self.selected = selected
        self.padding = padding
        self.action = action
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
        self.action = nil
    }
}

public class GraniteButtonCenter: GraniteCenter<GraniteButtonState> {
}
