//
//  AppDelegate.swift
//  Wonder
//
//  Created by Ritesh Pakala on 8/12/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import Granite
import AVFoundation
import UIKit
import Firebase
import CoreData

@UIApplicationMain
class AppDelegate: GraniteAppDelegate {
    
    var orientationLock = UIInterfaceOrientationMask.all
    var lockRotationToLast: Bool = false
    var lastRotation: UIInterfaceOrientationMask? = nil
    
    override func didLaunch() {
        FileManager.default.clearTmpDirectory()
        FirebaseApp.configure()
        
        coordinator.service.storage.set(GlobalDefaults.allLSVDefaults)
        coordinator.service.storage.set(GlobalDefaults.allVariableDefaults)
        
        super.didLaunch()
    }
    
    override func willStart() {
        coordinator.showHomeController()
        coordinator.showSceneController()
        coordinator.showDashboardController()
    }
    
    override func willEnterForeground() {
    }
    
    override func didBecomeActive() {
        coordinator.service.center.requestSubscriptionUpdate()
    }
}

extension GraniteCoordinator {
    func showHomeController() {
        push(HomeBuilder.build(self.service))
    }
    
    func showSceneController() {
        push(SceneBuilder.build(self.service), fromComponent: HomeComponent.self)
    }
    
    func showDashboardController() {
        push(DashboardBuilder.build(self.service), fromComponent: HomeComponent.self)
    }
}

extension ServiceCenter {
    public var debug: Bool {
        true
    }
    
    public var coreData: CoreDataManager {
        return CoreDataManager(name: "version0000")
    }
}

extension ServiceCenter {
    public struct Events {
        public struct SubscriptionUpdated: Event {}
    }
}
    

