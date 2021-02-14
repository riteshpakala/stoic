//
//  AssetGridState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine



public class AssetGridState: GraniteState {
    var type: AssetGridType
    var context: WindowType
    
    var assetData: [Asset] {
        payload?.object as? [Asset] ?? []
    }
    
    let leadingPadding: CGFloat
    
    public init(context: WindowType) {
        self.type = context.assetGridType
        self.leadingPadding = Brand.Padding.medium
        self.context = context
    }
    
    public init(_ type: AssetGridType,
                context: WindowType) {
        self.type = type
        self.leadingPadding = Brand.Padding.medium
        self.context = context
    }
    
    public init(_ leadingPadding: CGFloat,
                type: AssetGridType) {
        self.type = type
        self.leadingPadding = leadingPadding
        self.context = .unassigned
    }
    
    public init(_ leadingPadding: CGFloat) {
        self.type = .standard
        self.leadingPadding = leadingPadding
        self.context = .unassigned
    }
    
    public required init() {
        self.type = .standard
        self.leadingPadding = Brand.Padding.medium
        self.context = .unassigned
    }
}

public class AssetGridCenter: GraniteCenter<AssetGridState> {
    
}
