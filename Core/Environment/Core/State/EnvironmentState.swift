//
//  ExperienceState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class EnvironmentState: GraniteState {
    var activeWindowConfigs: [[WindowConfig]] = []
    
    var activeWindows: [[WindowComponent]] = []
    
    let config: EnvironmentConfig
    
    let route: Route
    //
    var count:Int = 0
    
    public init(_ route: Route?) {
        self.route = route ?? .none
        switch route {
        case .debug(let debugRoute):
            self.config = EnvironmentConfig.route(debugRoute)
        default:
            self.config = EnvironmentConfig.route(self.route)
        }
    }
    
    required init() {
        self.config = .none
        self.route = .none
    }
}

public class EnvironmentCenter: GraniteCenter<EnvironmentState> {
    let clockRelay = ClockRelay([StockEvents.GetMovers(),
                                 CryptoEvents.GetMovers()])
    
    //Dependencies
    lazy var envDependency: EnvironmentDependency = {
        self.hosted.fetch.router.env.bind(self)
    }()
    //
    
    public override var links: [GraniteLink] {
        [
            .event(\EnvironmentState.route,
                        EnvironmentEvents.Boot())
        ]
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            BootExpedition.Discovery(),
            MoversCryptoExpedition.Discovery(),
            MoversStockExpedition.Discovery()
        ]
    }
    
    public var environmentMinSize: CGSize {
        return .init(
            CGFloat(state.activeWindows.count == 0 ?
                        Int(EnvironmentStyle.minWidth) :
                        state.activeWindows[0].count)*WindowStyle.minWidth,
            CGFloat(state.activeWindows.count)*WindowStyle.minHeight)
    }
    
    public var environmentMaxSize: CGSize {
        return .init(
            CGFloat(state.activeWindows.count == 0 ?
                        Int(EnvironmentStyle.minWidth) :
                        state.activeWindows[0].count)*WindowStyle.maxWidth,
            CGFloat(state.activeWindows.count)*WindowStyle.maxHeight)
    }
}
