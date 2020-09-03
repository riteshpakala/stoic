//
//  OnboardingEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/30/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

struct OnboardingEvents {
    public struct UpdateStep: Event {
        let step: OnboardingStep
        let index: Int
        public init(step: OnboardingStep, index: Int) {
            self.step = step
            self.index = index
        }
    }
}
