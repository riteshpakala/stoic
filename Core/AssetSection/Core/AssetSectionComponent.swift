//
//  AssetSectionComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct AssetSectionComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<AssetSectionCenter, AssetSectionState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading) {
            HeaderComponent(state: .init(state.windowType.label))
            Spacer()
            
            VStack(alignment: .leading, spacing: Brand.Padding.medium) {
                AssetGridComponent()
                    .listen(to: command)
                    .payload(state.payload)
            }
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
        }
    }
}
