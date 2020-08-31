//
//  OnboardingBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/30/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

class OnboardingBuilder {
    static func build(
        _ service: Service) -> OnboardingComponent {
        return OnboardingComponent(
            service,
            .init(),
            OnboardingViewController())
    }
}
