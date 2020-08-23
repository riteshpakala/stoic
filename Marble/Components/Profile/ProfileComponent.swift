//
//  ProfileComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class ProfileComponent: Component<ProfileState> {
    override public var reducers: [AnyReducer] {
        [
            ShowSubscribeReducer.Reducible(),
            CheckCredentialStateReducer.Reducible(),
        ]
    }
    
    override public func didLoad() {
//        sendEvent(ProfileEvents.ShowSubscribe())
    }
}
