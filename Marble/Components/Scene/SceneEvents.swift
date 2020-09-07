//
//  SceneViewEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct SceneEvents {
    public struct ChangeScene: Event {
        let scene: SceneType
        public init(scene: SceneType) {
            self.scene = scene
        }
    }
}

