//
//  ProfileBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

class ProfileBuilder {
    static func build(
        _ service: Service) -> ProfileComponent {
        return ProfileComponent(
            service,
            .init(),
            ProfileViewController())
    }
}
