//
//  RouterComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine
import Firebase

public struct RouterComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<RouterCenter, RouterState> = .init()
    
    public init() {
        FirebaseApp.configure()
    }
    
    public var body: some View {
        MainComponent().share(.init(dep(\.routerDependency)))
    }
}
