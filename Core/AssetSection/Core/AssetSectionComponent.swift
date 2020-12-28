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
        VStack(alignment: .leading, spacing: Brand.Padding.xSmall) {
            Spacer().frame(height: Brand.Padding.large)
            Text(state.title)
                .granite_innerShadow(
                Brand.Colors.white,
                radius: 4,
                offset: .init(x: 2, y: 2))
                .multilineTextAlignment(.leading)
                .font(Fonts.live(.title, .bold))
                .padding(.leading, 12)
            
            VStack(alignment: .leading, spacing: Brand.Padding.medium) {
                AssetGridComponent().payload(state.payload)
                AssetGridComponent().payload(state.payload)
            }
        }.background(Color.black)
    }
}
