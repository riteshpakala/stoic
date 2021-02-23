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
    
    var routerDependency: RouterDependency {
        hosted.fetch.add(self)
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            UserExpedition.Discovery(),
            LogoutExpedition.Discovery(),
            DiscussSetResultExpedition.Discovery(),
            LoginResultExpedition.Discovery(),
            LoginAuthCompleteExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(MainEvents.User(), .dependant)
        ]
    }
    
    var authState: AuthState {
        routerDependency.authState
    }
}
