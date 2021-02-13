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
                HStack(spacing: Brand.Padding.large) {
                    GraniteText(state.label,
                                .subheadline,
                                .regular,
                                .leading)
                    
                    Spacer()
                    
                    if command.center.showDescription1 {
                        GraniteText("price",
                                    .subheadline,
                                    .regular,
                                    .trailing)
                    }
                    
                    if command.center.showDescription2 {
                        switch state.assetGridType {
                        case .standard:
                            GraniteText("change",
                                        .subheadline,
                                        .regular).frame(width: 60)
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
                }
                .padding(.bottom, Brand.Padding.xSmall)
                .padding(.leading, state.leadingPadding.isZero ? Brand.Padding.small : state.leadingPadding)
                .padding(.trailing, Brand.Padding.medium)
                
                Rectangle()
                    .frame(height: 2.0, alignment: .leading).foregroundColor(.black)
            }.frame(minHeight: 42, idealHeight: 42, maxHeight: 42)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(state.assetData, id: \.assetID) { asset in
                        AssetGridItemComponent(state: .init(state.assetGridType,
                                                            radioSelections: state.radioSelections))
                            .payload(.init(object: asset))
                            .padding(.top, Brand.Padding.small)
                            .modifier(TapAndLongPressModifier(
                                        tapAction: {
                                                if state.assetGridType == .radio {
                                                    var selections = state.radioSelections
                                                    if selections.contains(asset.assetID) {
                                                        selections.removeAll(where: { $0 == asset.assetID })
                                                    } else {
                                                        selections.append(asset.assetID)
                                                    }
                                                    Haptic.basic()
                                                    return set(\.radioSelections, value: selections)
                                                } else {
                                                    
                                                    return sendEvent(AssetGridItemContainerEvents
                                                                        .AssetTapped(
                                                                            asset),
                                                                    .contact,
                                                                    haptic: .light)
                                                }
                                        }))
                            .padding(.leading, state.leadingPadding.isZero ? Brand.Padding.small : state.leadingPadding)
                    }.padding(.leading, state.leadingPadding.isZero ? 0 : Brand.Padding.medium)
                }
            }.frame(maxWidth: .infinity,
                    minHeight: state.assetData.count > 0 ? 66 : 0.0,
                    alignment: .center)
            
            if state.assetGridType == .radio {
                Spacer()
                GraniteButtonComponent(state: .init("confirm",
                                                    action: {
                                                        if self.state.radioSelections.isNotEmpty {
                                                            return sendEvent(AssetGridItemContainerEvents
                                                                                .AssetsSelected(
                                                                                    state.radioSelections),
                                                                                .contact,
                                                                                haptic: .light)
                                                        }
                                                    }))
                    .opacity(state.radioSelections.isEmpty ? 0.5 : 1.0)
            }
        }
    }
}
