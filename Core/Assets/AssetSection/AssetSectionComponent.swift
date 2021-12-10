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
            GraniteText("last updated: \(command.center.date.asStringWithTime)",
                        Brand.Colors.marble,
                        .footnote,
                        .regular,
                        .leading)
                        .padding(.top, Brand.Padding.medium)
                        .padding(.leading, Brand.Padding.medium)
                        .padding(.bottom, Brand.Padding.small)
            HStack {
                if command.center.toggleTitle {
                    GraniteToggle(options: .init(command.center.toggleTitleLabels,
                                                 padding: Brand.Padding.medium), onToggle: { index in
                        set(\.toggleTitleIndex, value: index)
                    })
                    .padding(.leading, Brand.Padding.small)
                } else {
                    GraniteText(state.context.label, .headline, .bold)
                }
                Spacer()
                GraniteToggle(options: .init(["stock", "crypto"],
                                             padding: Brand.Padding.medium), onToggle: { index in
                    set(\.securityType, value: index == 0 ? .stock : .crypto)
                })
                
//                #if DEBUG
//                GraniteButtonComponent(state: .init(.image("refresh_icon"),
//                                                    colors: [Brand.Colors.yellow,
//                                                             Brand.Colors.purple],
//                                                    selected: true,
//                                                    size: .init(16),
//                                                    padding: .init(0,
//                                                                   Brand.Padding.xMedium,
//                                                                   Brand.Padding.xSmall,
//                                                                   Brand.Padding.small),
//                                                    action: {
//                                                        GraniteHaptic.light.invoke()
//                                                        sendEvent(AssetSectionEvents.Refresh(sync: true))
//                                                    }))
//                #endif
                
                GraniteButtonComponent(state: .init(.image("refresh_icon"),
                                                    selected: true,
                                                    size: .init(16),
                                                    padding: .init(0,
                                                                   Brand.Padding.xMedium,
                                                                   Brand.Padding.xSmall,
                                                                   Brand.Padding.small),
                                                    action: {
                                                        GraniteHaptic.light.invoke()
                                                        sendEvent(AssetSectionEvents.Refresh())
                                                    }))
            }
            .padding(.leading, Brand.Padding.medium)
            .padding(.trailing, Brand.Padding.medium)
            VStack(alignment: .leading, spacing: Brand.Padding.medium) {
                AssetGridComponent(state: .init(context: state.context,
                                                assetData: command.center.movers))
                    .listen(to: command, .stop)
                    .showEmptyState
            }
        }
    }
}
