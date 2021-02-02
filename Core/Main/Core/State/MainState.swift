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

public class MainState: GraniteState {
}

public class MainCenter: GraniteCenter<MainState> {
    let networkRelay: NetworkRelay = .init()
    
    var routerDependency: RouterDependency {
        return (dependency.hosted as? RouterDependency ?? .init(identifier: "none"))
    }
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            UserExpedition.Discovery(),
            LoginResultExpedition.Discovery()
        ]
    }
    
    public override var links: [GraniteLink] {
        [
            .onAppear(MainEvents.User(), .dependant)
        ]
    }
    
    var isAuthenticated : Bool {
        routerDependency.router.env.user.info.isReady && FirebaseAuth.Auth.auth().currentUser != nil
    }
}
