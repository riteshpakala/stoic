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
    
    let columns = [
        GridItem(.flexible()),
    ]
    
    public var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(0...100, id: \.self) { _ in
                    AssetGridItemComponent().payload(state.payload).frame(minWidth: 300, idealWidth: 414, maxWidth: 420, minHeight: 48, idealHeight: 50, maxHeight: 75, alignment: .leading)
                }
            }
        }
    }
}
