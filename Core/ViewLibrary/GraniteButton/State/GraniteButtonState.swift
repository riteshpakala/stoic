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
    
    let textColor: Color
    let textColors: [Color]
    let textShadow: Color
    
    public init(_ text: String,
                textColor: Color = Brand.Colors.black,
                colors: [Color] = [Brand.Colors.marbleV2,
                                   Brand.Colors.marble.opacity(0.42)],
                shadow: Color = Color.black.opacity(0.57),
                padding: EdgeInsets = .init(Brand.Padding.large,
                                            Brand.Padding.medium,
                                            Brand.Padding.large,
                                            Brand.Padding.medium) ,
                action: (() -> Void)? = nil) {
        self.type = .text(text)
        self.selected = false
        self.size = .zero
        self.selectionColor = .black
        self.padding = padding
        self.action = action
        
        self.textColor = textColor
        self.textColors = colors
        self.textShadow = shadow
        
    }
    
    public init(_ type: GraniteButtonType,
                colors: [Color] = [Brand.Colors.marbleV2,
                                   Brand.Colors.marble],
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
        
        self.textColor = Brand.Colors.black
        self.textColors = colors
        self.textShadow = Brand.Colors.black.opacity(0.57)
        
//        [Brand.Colors.marbleV2.opacity(0.66),
//                           Brand.Colors.marble]
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
        
        self.textColor = Brand.Colors.black
        self.textColors = [Brand.Colors.marbleV2.opacity(0.66), Brand.Colors.marble]
        self.textShadow = Brand.Colors.black.opacity(0.57)
    }
}

public class GraniteButtonCenter: GraniteCenter<GraniteButtonState> {
}
