//
//  AppCoord+Scene.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import SnapKit

/*
 
 SceneViewController Controller Delegates
 
 */

extension AppCoordinator {
    func showSceneController() {
        homeComponent?.push(
            SceneBuilder.build(
                self.services,
                parent: homeComponent),
            fit: true)
    }
}
