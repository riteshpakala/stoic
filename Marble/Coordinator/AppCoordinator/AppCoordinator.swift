//
//  AppCoordinator.swift
//
//
//  Created by Ritesh Pakala on 2/21/19.
//  Copyright © 2019 Ritesh Pakala. All rights reserved.
//

import AudioToolbox
import Foundation
import Firebase
import UIKit
import UserNotifications

/// The AppCoordinator is our first coordinator
/// In this example the AppCoordinator as a rootViewController
class AppCoordinator: RootViewCoordinator {
    
    // MARK: - Properties
    let services: Services
    let notificationCenter: UNUserNotificationCenter
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Components
    var homeComponent: HomeComponent? = nil
    
    var rootViewController: UIViewController {
        return self.navigationController
    }
    
    /// Window to manage
    let window: UIWindow
    
    lazy var navigationController: RootNavigationController = {
        let navigationController = RootNavigationController(nibName: nil, bundle: nil)
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    
    // MARK: - Init
    public init(window: UIWindow, services: Services) {
        self.services = services
        self.window = window
        self.notificationCenter = UNUserNotificationCenter.current()
        
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }
    
    // MARK: - Functions
    
    /// Starts the coordinator
    public func start() {
        
        loadDefaults()
        
        self.showHomeController()
        self.showSceneController()
        self.showDashboardController()
    }
    
    public func loadDefaults() {
    }
}
