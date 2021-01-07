//
//  GraphComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/6/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct GraphComponent: GraniteComponent {
    @ObservedObject
    public var command: GraniteCommand<GraphCenter, GraphState> = .init()
    
    public init() {}
    
    public var body: some View {
        GraphPage(someModel: command.center.plotData)
            .onAppear(perform: sendEvent(GraphEvents.Set()))
    }
}
