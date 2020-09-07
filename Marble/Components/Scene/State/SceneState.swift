//
//  SceneViewState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

public enum SceneType: Int {
    case minimized
    case home
    case custom
}

public class SceneState: State {
    @objc dynamic var scene: Int = SceneType.home.rawValue
}
