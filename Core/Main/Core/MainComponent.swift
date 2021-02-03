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
    
    public init() {}
    
    var environment: EnvironmentComponent {
        EnvironmentComponent(state: .init(inject(\.routerDependency,
                                                    target: \.router.route)))
    }
    
    var controls: ControlBar {
        ControlBar(isIPhone: EnvironmentConfig.isIPhone,
                   currentRoute: command.center.routerDependency.router.route,
                   onRoute: { route in
            command.center.routerDependency.router.request(route)
        })
    }
    
    func checkSafeArea(_ inset: CGFloat) -> CGFloat {
        return inset >= 0 ? inset : Brand.Padding.large
    }
    
    public var body: some View {
        switch command.center.authState {
        case .authenticated:
            if EnvironmentConfig.isIPhone {
                GeometryReader { proxy in
                    ZStack(alignment: .top) {
                        VStack {
                            environment
                                .share(.init(dep(\.routerDependency)))
                                .listen(to: command)
                                .iDevicePadding(proxy.safeAreaInsets.topBottom)
                                .padding(.top, checkSafeArea(proxy.safeAreaInsets.top))
                            controls
                        }
                        .ignoresSafeArea(/*@START_MENU_TOKEN@*/.keyboard/*@END_MENU_TOKEN@*/, edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
                        .background(Color.black)
                        
                        
                        Rectangle()
                            .frame(maxWidth: .infinity,
                                    minHeight: checkSafeArea(proxy.safeAreaInsets.top),
                                    idealHeight: checkSafeArea(proxy.safeAreaInsets.top),
                                    maxHeight: checkSafeArea(proxy.safeAreaInsets.top),
                                    alignment: .center)
                            .foregroundColor(controls.currentRoute == .discuss ? Color.black : Brand.Colors.black)
                    }.ignoresSafeArea(edges: .top)
                }
            } else {
                HStack {
                    controls
                    environment
                        .share(.init(dep(\.routerDependency)))
                        .listen(to: command)
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                .background(Color.black)
            }
        case .notAuthenticated:
            LoginComponent().share(.init(dep(\.routerDependency)))
        case .none:
            GraniteLoadingComponent()
        }
    }
}
