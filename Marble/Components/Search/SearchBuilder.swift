//
//  SearchBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

class SearchBuilder {
    static func build(
        _ services: Services,
        parent: AnyComponent? = nil) -> SearchComponent {
        return SearchComponent(
            services,
            .init(),
            SearchViewController(),
            parent: parent)
    }
}
