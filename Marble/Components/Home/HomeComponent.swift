//
//  HomeViewComponent.swift
//  Marble
//
//  Created by Ritesh Pakala on 5/14/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class HomeComponent: Component<HomeState> {
    override public var reducers: [AnyReducer] {
        [
            UpdateSceneReducer.Reducible(),
            AllDetailsDidCloseReducer.Reducible(),
            PresentAlertControllerReducer.Reducible(),
            PresentAlertReducer.Reducible()
        ]
    }
}
