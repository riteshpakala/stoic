//
//  DashboardBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/4/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

class DashboardBuilder {
    static func build(
        _ services: Services,
        parent: AnyComponent? = nil) -> DashboardComponent {
    
        return DashboardComponent(
            services,
            .init(),
            DashboardViewController(),
            parent: parent)
    }
}
