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
    
    //TODO:
    //Memory leaks with Subscribers that are not cancelled
    //during component re-draw phases of an application
    var clockRelay: ClockRelay {
        var clock = ClockRelay([StockEvents.GetMovers(),
                                CryptoEvents.GetMovers()])

        clock.enabled = false//state.config.kind == .home

        return clock
    }
    
    //Dependencies
    lazy var envDependency: EnvironmentDependency = {
        self.hosted.fetch.router.env.bind(self)
    }()
    //
    
    public override var relays: [GraniteBaseRelay] {
        [
            clockRelay
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .event(\EnvironmentState.route,
                        EnvironmentEvents.Boot()),
            .event(\EnvironmentState.route,
                        EnvironmentEvents.User())
        ]
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            BootExpedition.Discovery(),
            UserExpedition.Discovery(),
            MoversCryptoExpedition.Discovery(),
            MoversStockExpedition.Discovery()
        ]
    }
    
    public var environmentMinSize: CGSize {
        return .init(
            CGFloat(state.activeWindowConfigs.count == 0 ?
                        Int(EnvironmentStyle.minWidth) :
                        state.activeWindowConfigs[0].count)*WindowStyle.minWidth,
            CGFloat(state.activeWindowConfigs.count)*WindowStyle.minHeight)
    }
    
    public var environmentMaxSize: CGSize {
        return .init(
            CGFloat(state.activeWindowConfigs.count == 0 ?
                        Int(EnvironmentStyle.minWidth) :
                        state.activeWindowConfigs[0].count)*WindowStyle.maxWidth,
            CGFloat(state.activeWindowConfigs.count)*WindowStyle.maxHeight)
    }
}
