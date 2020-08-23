//
//  HomeBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/4/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

class HomeBuilder {
    static func build(
        _ service: Service) -> HomeComponent {
        
        return HomeComponent(
            service,
            .init(),
            HomeViewController())
    }
}
