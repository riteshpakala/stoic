//
//  SceneBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/4/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

class SceneBuilder {
    static func build(
        _ service: Service) -> SceneComponent {
        
        return SceneComponent(
            service,
            .init(),
            SceneViewController())
    }
}
