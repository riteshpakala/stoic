//
//  CollectionBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/4/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

class LiveSearchCollectionBuilder {
    static func build(
        _ services: Services,
        parent: AnyComponent? = nil) -> LiveSearchCollectionComponent {
        
        return LiveSearchCollectionComponent(
            services,
            .init(),
            LiveSearchCollectionViewController(),
            parent: parent)
    }
}
