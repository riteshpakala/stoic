//
//  Router.Onboarding.Models.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/30/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
import Granite
import Firebase

//MARK: Onboarding
extension Onboardable {
    public var onboardingProperties: OnboardingProperties {
        .init(
            backgroundColor: GlobalStyle.Colors.yellow.withAlphaComponent(0.15),
            textColor: GlobalStyle.Colors.yellow,
            textFont: GlobalStyle.Fonts.courier(.medium, .bold),
            textBackgroundColor: GlobalStyle.Colors.black.withAlphaComponent(0.75))
    }
}
