//
//  PresentAlertReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/11/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

struct PresentAlertReducer: Reducer {
    typealias ReducerEvent = HomeEvents.PresentAlertController
    typealias ReducerState = HomeState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(event.alert, animated: true, completion: nil)
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let vc = base ?? UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        if let nav = vc as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = vc as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = vc?.presentedViewController {
            return topViewController(base: presented)
        }
        return vc
    }
}
