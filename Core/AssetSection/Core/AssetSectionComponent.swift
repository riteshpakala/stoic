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
    
    public init() {
        
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                GraniteText(state.windowType.label, .headline, .bold)
                Spacer()
                GraniteToggle(options: .init(["stock", "crypto"]), onToggle: { index in
                    set(\.securityType, value: index == 0 ? .stock : .crypto)
                })
            }
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            VStack(alignment: .leading, spacing: Brand.Padding.medium) {
                AssetGridComponent(state: .init(.standard, context: state.windowType))
                    .listen(to: command)
                    .payload(.init(object: command.center.movers)).showEmptyState
            }
        }
        .padding(.top, Brand.Padding.large)
    }
}
