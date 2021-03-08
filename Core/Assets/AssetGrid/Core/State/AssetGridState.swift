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
    
    var assetData: [Asset]
    let leadingPadding: CGFloat
    
    var radioSelections: [String] = []
    
    var label: String {
        switch assetData.first?.assetType {
        case .model:
            return "model"
        case .security:
            
            let stockType = assetData.first(where: { $0.asSecurity?.securityType == .stock })
            let cryptoType = assetData.first(where: { $0.asSecurity?.securityType == .crypto })
            
            let bothExists = stockType != nil && cryptoType != nil
            
            if bothExists {
                return "security"
            } else {
                let typeLabel = stockType?.asSecurity?.securityType ?? cryptoType?.asSecurity?.securityType
                return "\(typeLabel?.rawValue ?? "security")"
            }
            
        case .user:
            return "user"
        default:
            return "asset"
        }
    }
    
    public init(context: WindowType, assetData: [Asset]) {
        self.type = context.assetGridType
        self.leadingPadding = Brand.Padding.medium
        self.context = context
        self.assetData = assetData
    }
    
    public init(_ type: AssetGridType,
                context: WindowType, assetData: [Asset]) {
        self.type = type
        self.leadingPadding = Brand.Padding.medium
        self.context = context
        self.assetData = assetData
    }
    
    public init(_ leadingPadding: CGFloat,
                type: AssetGridType, assetData: [Asset]) {
        self.type = type
        self.leadingPadding = leadingPadding
        self.context = .unassigned
        self.assetData = assetData
    }
    
    public init(_ leadingPadding: CGFloat, assetData: [Asset]) {
        self.type = .standard
        self.leadingPadding = leadingPadding
        self.context = .unassigned
        self.assetData = assetData
    }
    
    public required init() {
        self.type = .standard
        self.leadingPadding = Brand.Padding.medium
        self.context = .unassigned
        self.assetData = []
    }
}

public class AssetGridCenter: GraniteCenter<AssetGridState> {
    var isComplete: Bool {
        state.assetData.filter{ $0.isIncomplete }.isEmpty
    }
    
    var showDescription1: Bool {
        state.assetData.first?.showDescription1 == true
    }
    
    var showDescription2: Bool {
        state.assetData.first?.showDescription2 == true
    }
    
    var assetType: AssetType {
        state.assetData.first?.assetType ?? .security
    }
}
