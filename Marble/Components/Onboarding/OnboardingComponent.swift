//
//  OnboardingComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/30/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class OnboardingComponent: Component<OnboardingState> {
    override public var reducers: [AnyReducer] {
        [
            UpdateStepReducer.Reducible()
        ]
    }
    
    override public func didLoad() {
        
    }
}
