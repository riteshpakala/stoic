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
        
        let componenToPass = component
        DispatchQueue.main.async {
            if LSConst.Device.isIPad, let popover = event.alert.popoverPresentationController {
                popover.sourceView = componenToPass.viewController?.view
                
                let midX = componenToPass.viewController?.view.frame.midX ?? UIScreen.main.bounds.width/2
                let midY = componenToPass.viewController?.view.frame.height ?? UIScreen.main.bounds.height
                
                popover.sourceRect = CGRect(x: midX, y: midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            UIApplication.topViewController()?.present(event.alert, animated: true, completion: nil)
        }
    }
}
