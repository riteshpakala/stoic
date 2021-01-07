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
                    
                    GraniteText("change",
                                .subheadline,
                                .regular)
                    
                }
                .padding(.bottom, Brand.Padding.xSmall)
                
                Rectangle().frame(height: 2.0, alignment: .leading).foregroundColor(.black)
            }.frame(minHeight: 42, idealHeight: 42, maxHeight: 42)
            
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 0.0) {
                        ForEach(0..<state.securityData.count, id: \.self) { index in
                            AssetGridItemComponent().payload(.init(object: state.securityData[index])).onTapGesture(
                                perform: sendEvent(
                                    AssetGridItemContainerEvents
                                        .SecurityTapped(
                                            state.securityData[index]), contact: true))
                        }
                    }.padding(.leading, Brand.Padding.medium)
                }
            }
        }
    }
}
