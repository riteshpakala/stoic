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
                if command.center.toggleTitle {
                    GraniteToggle(options: .init(command.center.toggleTitleLabels), onToggle: { index in
                        set(\.toggleTitleIndex, value: index)
                    })
                } else {
                    GraniteText(state.context.label, .headline, .bold)
                }
                Spacer()
                GraniteToggle(options: .init(["stock", "crypto"]), onToggle: { index in
                    set(\.securityType, value: index == 0 ? .stock : .crypto)
                })
                
                GraniteButtonComponent(state: .init(.image("refresh_icon"),
                                                    selected: true,
                                                    size: .init(16),
                                                    padding: .init(0,
                                                                   Brand.Padding.large,
                                                                   Brand.Padding.xSmall,
                                                                   Brand.Padding.small),
                                                    action: {
                                                            GraniteHaptic.light.invoke()
                                                    }))
            }
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            VStack(alignment: .leading, spacing: Brand.Padding.medium) {
                AssetGridComponent(state: .init(context: state.context))
                    .listen(to: command, .stop)
                    .payload(.init(object: command.center.movers)).showEmptyState
            }
        }
        .padding(.top, Brand.Padding.large)
    }
}
