//
//  AssetGridComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct AssetGridComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<AssetGridCenter, AssetGridState> = .init()
    
    public init() {}
    
    let columns = [
        GridItem(.flexible()),
    ]
    
    public var body: some View {
        VStack {
            itemContainer
                .frame(
//                     minWidth: 300 + Brand.Padding.large,
//                       idealWidth: 414 + Brand.Padding.large,
                    maxWidth: .infinity,//420 + Brand.Padding.large,
//                       minHeight: 48 * 5,
//                       idealHeight: 50 * 5,
                    maxHeight: .infinity,//75 * 5,
                    alignment: .leading)
        }
    }
    
    var itemContainer: some View {
        VStack {
            VStack(alignment: .leading, spacing: 0.0) {
                Spacer()
                HStack(spacing: Brand.Padding.medium) {
                    GraniteText(state.label,
                                .subheadline,
                                .regular,
                                .leading)
                    
                    if command.center.isComplete {
                        if command.center.showDescription1 {
                            switch command.center.assetType {
                            case .model:
                                GraniteText("expires",
                                            .subheadline,
                                            .regular,
                                            .trailing)
                            default:
                                GraniteText("price",
                                            .subheadline,
                                            .regular,
                                            .trailing)
                            }
                        }
                        
                        if command.center.showDescription2 {
                            switch state.type {
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
                        AssetGridItemComponent(state: .init(state.type,
                                                            radioSelections: state.radioSelections,
                                                            asset: asset))
                            .padding(.top, Brand.Padding.small)
                            .modifier(TapAndLongPressModifier(
                                        tapAction: {
                                                if state.type == .radio {
                                                    var selections = state.radioSelections
                                                    if selections.contains(asset.assetID) {
                                                        selections.removeAll(where: { $0 == asset.assetID })
                                                    } else {
                                                        selections.append(asset.assetID)
                                                    }
                                                    Haptic.basic()
                                                    return set(\.radioSelections, value: selections)
                                                } else {
                                                    
                                                    return sendEvent(AssetGridEvents
                                                                        .AssetTapped(
                                                                            asset),
                                                                    .contact,
                                                                    haptic: .light)
                                                }
                                        }))
                            .padding(.leading, state.leadingPadding.isZero ? Brand.Padding.small : state.leadingPadding)
                    }//.padding(.leading, state.leadingPadding.isZero ? 0 : Brand.Padding.medium)
                }
            }.frame(maxWidth: .infinity,
                    minHeight: state.assetData.count > 0 ? 66 : 0.0,
                    alignment: .center)
            
            if state.type == .radio {
                Spacer()
                GraniteButtonComponent(state: .init("confirm",
                                                    action: {
                                                        if self.state.radioSelections.isNotEmpty {
                                                            return sendEvent(AssetGridEvents
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

//MARK: -- Empty State Settings
extension AssetGridComponent {
    
    public var emptyText: String {
        switch state.context {
        case .holdings,
             .portfolio:
            return "add & save a security\nfor easy access"
        case .floor:
            return "add & save\na security to\nyour trading floor"
        case .tonalBrowser:
            return "create & save a tonal model\nfor it to appear here"
        case .topVolume,.winners,.losers,.winnersAndLosers:
            return "fetching..."
        default:
            return ""
        }
        
    }
    
    public var isDependancyEmpty: Bool {
        switch state.context {
        case .holdings,
             .portfolio,
             .floor,
             .topVolume,
             .winners,
             .losers,
             .winnersAndLosers:
            let securities: [Security]? = (state.assetData as? [Security])
            return securities == nil || securities?.isEmpty == true
        case .tonalBrowser:
            return (state.assetData as? [TonalModel])?.isEmpty == true
        default:
            return false
        }
    }
    
    public var emptyPayload: GranitePayload? {
        switch state.context {
        case .holdings,
             .portfolio,
             .floor:
            return .init(object: [Brand.Colors.yellow, Brand.Colors.redBurn])
        case .tonalBrowser:
            return .init(object: [Brand.Colors.redBurn, Brand.Colors.yellow])
        default:
            return nil
        }
    }
    
}
