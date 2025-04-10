//
//  SceneViewComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class SceneComponent: Component<SceneState> {
    override public var reducers: [AnyReducer] {
        [
            ChangeSceneReducer.Reducible()
        ]
    }
}
