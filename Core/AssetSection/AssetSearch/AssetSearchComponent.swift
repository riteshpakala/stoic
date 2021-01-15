//
//  AssetSearchComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/7/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct AssetSearchComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<AssetSearchCenter, AssetSearchState> = .init()
    
    public init() {}
    
    var empty: some View {
        print("{TEST} \(command.center.securities?.count)")
        return EmptyView.init()
    }
    public var body: some View {
        VStack {
            SearchComponent(
                state: state.searchState)
                .share(.init(dep(\.hosted,
                                 AssetSearchCenter.route)))
            
            HStack {
                Spacer()
                GraniteToggle(options: .init(["stock", "crypto"]), onToggle: { index in
                    set(\.securityType, value: index == 0 ? .stock : .crypto)
                })
                Spacer()
            }.padding(.top, Brand.Padding.medium)
            
            if command.center.securities?.isNotEmpty == true {
                empty
                AssetGridComponent(state: command.center.assetGridState)
                    .payload(.init(object: command.center.securities))
                    .listen(to: command, .stop)
            }
        }
        .padding(.top, Brand.Padding.large)
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
        .padding(.bottom, state.securityData.isNotEmpty ? 0.0 : Brand.Padding.large)
    }
}
