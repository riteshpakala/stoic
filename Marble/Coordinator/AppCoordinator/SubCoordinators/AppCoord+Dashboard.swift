//
//  AppCoord+Dashboard.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import SnapKit

/*
 
 DashboardViewController Controller Delegates
 
 */

extension AppCoordinator {
    func showDashboardController() {
        
        homeComponent?.push(
            DashboardBuilder.build(
                self.services,
                parent: homeComponent),
            fit: true)
    }
}
