//
//  AssetGridItemContainerComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/22/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct AssetGridItemContainerComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<AssetGridItemContainerCenter, AssetGridItemContainerState> = .init()
    
    public init() {}
    
    let columns = [
        GridItem(.flexible()),
    ]
    
    public var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0.0) {
                Spacer()
                HStack(spacing: 0.0) {
                    GraniteText(state.label,
                                .subheadline,
                                .regular,
                                .leading)
                    
                    Spacer()
                    
                    GraniteText("price",
                                .subheadline,
                                .regular)
                                .padding(.trailing,
                                         Brand.Padding.large)
                    
                    switch state.assetGridType {
                    case .standard:
                        GraniteText("change",
                                    .subheadline,
                                    .regular)
                    case .add:
                        GraniteText("add",
                                    .subheadline,
                                    .regular)
                    case .radio:
                        GraniteText("select",
                                    .subheadline,
                                    .regular)
                    default:
                        EmptyView.init()
                    }
                    
                    
                }
                .padding(.bottom, Brand.Padding.xSmall)
                
                Rectangle().frame(height: 2.0, alignment: .leading).foregroundColor(.black)
            }.frame(minHeight: 42, idealHeight: 42, maxHeight: 42)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(state.assetData, id: \.assetID) { asset in
                        AssetGridItemComponent(state: .init(state.assetGridType)).payload(.init(object: asset)).onTapGesture(
                            perform: sendEvent(
                                AssetGridItemContainerEvents
                                    .AssetTapped(
                                        asset),
                                .contact,
                                haptic: .light))
                    }.padding(.leading, Brand.Padding.medium)
                }
            }.frame(maxWidth: .infinity,
                    minHeight: state.assetData.count > 0 ? 48 : 0.0,
                    alignment: .center)
        }
    }
}
