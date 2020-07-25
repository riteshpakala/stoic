//
//  AppCoord+Home.swift
//  DeepCrop
//
//  Created by Ritesh Pakala on 5/7/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import Foundation

/*
 
 HomeViewController Controller Delegates
 
 */

extension AppCoordinator {
    func showHomeController() {
        self.homeComponent = HomeBuilder.build(self.services)
        
        self.navigationController.viewControllers = [homeComponent!.viewController!]
    }
}
