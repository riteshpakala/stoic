//
//  HomeBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/4/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

class HomeBuilder {
    static func build(
        _ services: Services,
        parent: AnyComponent? = nil) -> HomeComponent {
        
        return HomeComponent(
            services,
            .init(),
            HomeViewController(),
            parent: parent)
    }
}
