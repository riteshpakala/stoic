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
    
    public var body: some View {
        VStack {
            SearchComponent(
                state: state.searchState)
                .share(.init(dep(\.hosted,
                                 AssetSearchCenter.route)))
            
            switch state.context {
            case .holdings:
                AssetGridComponent(state: .init(.add))
                    .payload(retrievePayload(\.envDependency,
                                       target: \.searchAdd.securities))
                    .listen(to: command, .stop)
            case .tonalCreate:
                AssetGridComponent()
                    .payload(retrievePayload(\.envDependency,
                                       target: \.searchTone.securities))
                    .listen(to: command, .stop)
            case .search:
                AssetGridComponent()
                    .payload(retrievePayload(\.envDependency,
                                       target: \.search.securities))
                    .listen(to: command, .stop)
            default:
                EmptyView.init()
            }
        }
        .padding(.top, Brand.Padding.large)
        .padding(.leading, Brand.Padding.medium)
        .padding(.trailing, Brand.Padding.medium)
    }
}
