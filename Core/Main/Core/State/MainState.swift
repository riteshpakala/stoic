//
//  MainState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/19/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine
import CryptoKit
import Firebase

public enum MainStage {
    case authenticated
    case willAuthenticate
    case none
}
public class MainState: GraniteState {
    var stage: MainStage = .none
}

public class MainCenter: GraniteCenter<MainState> {
    let networkRelay: NetworkRelay = .init()
    let discussRelay: DiscussRelay = .init()
    
    @GraniteInject
    var routerDependency2: RouterDependency2
    
    @GraniteInject
    var envDependency2: EnvironmentDependency2
    
    @GraniteInject
    var discussDependency: DiscussDependency
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            RouteExpedition.Discovery(),
            UserExpedition.Discovery(),
            LogoutExpedition.Discovery(),
            DiscussSetResultExpedition.Discovery(),
            LoginResultExpedition.Discovery(),
            LoginAuthCompleteExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(MainEvents.User())
        ]
    }
    
    var authState: AuthState {
        routerDependency2.authState
    }
}
