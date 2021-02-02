//
//  SpecialState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/11/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class SpecialState: GraniteState {
    var scene: SceneKitView = SceneKitView()
}

public class SpecialCenter: GraniteCenter<SpecialState> {
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            SetupSceneExpedition.Discovery()
        ]
    }
}
