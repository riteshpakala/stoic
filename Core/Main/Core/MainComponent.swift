//
//  MainComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct MainComponent: GraniteComponent {
    
    @ObservedObject
    public var command: GraniteCommand<MainCenter, MainState> = .init()
    
    
    public init() {
        command
            .center
            .routerDependency
            .router
            .refreshable = command.center
    }
    
    var environment: EnvironmentComponent {
        EnvironmentComponent(state: .init(inject(\.routerDependency,
                                                    target: \.router.route)))
    }
    
    var controls: ControlBar {
        ControlBar(isIPhone: EnvironmentConfig.isIPhone,
                   currentRoute: command.center.routerDependency.router.route.convert(to: Route.self) ?? .home,
                   onRoute: { route in
                sendEvent(MainEvents.RequestRoute.init(route: route))
        })
    }
    
    public var body: some View {
        switch command.center.authState {
        case .authenticated:
            if EnvironmentConfig.isIPhone {
                VStack(spacing: 0) {
                    environment
                        .listen(to: command)
                    controls
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            } else {
                HStack {
                    controls
                    environment
                        .listen(to: command)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                .background(Color.black)
            }
        case .notAuthenticated:
            LoginComponent()
                .listen(to: command)
        case .none:
            GraniteLoadingComponent()
        }
    }
}
