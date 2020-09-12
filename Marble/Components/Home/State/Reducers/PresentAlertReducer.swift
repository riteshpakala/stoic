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
