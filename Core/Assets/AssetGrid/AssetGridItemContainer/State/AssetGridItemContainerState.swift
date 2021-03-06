//
//  AssetGridItemContainerState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class AssetGridItemContainerState: GraniteState {
    var assetData: [Asset] = []
    
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
    
    let assetGridType: AssetGridType
    let leadingPadding: CGFloat
    
    public init(_ type: AssetGridType,
                leadingPadding: CGFloat,
                assetData: [Asset]) {
        assetGridType = type
        self.leadingPadding = leadingPadding
        self.assetData = assetData
    }
    
    public required init() {
        self.assetGridType = .standard
        self.leadingPadding = Brand.Padding.medium
        self.assetData = []
    }
}

public class AssetGridItemContainerCenter: GraniteCenter<AssetGridItemContainerState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            MoversSecurityExpedition.Discovery()
        ]
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
