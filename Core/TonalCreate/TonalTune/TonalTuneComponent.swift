//
//  TonalTuneComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/26/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct TonalTuneComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<TonalTuneCenter, TonalTuneState> = .init()
    
    public init() {}
    
    public var body: some View {
        VStack {}
    }
}
