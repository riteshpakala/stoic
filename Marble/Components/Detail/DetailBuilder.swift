//
//  DetailBuilder.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/4/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

class DetailBuilder {
    static func build(
        _ service: Service,
        _ searchedStock: SearchStock) -> DetailComponent {
    
        return DetailComponent(
            service,
            .init(searchedStock),
            DetailViewController())
    }
}
