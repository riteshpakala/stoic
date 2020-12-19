//
//  StockComponent.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/18/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public struct StockRelay: GraniteRelay {
    @ObservedObject
    public var command: GraniteService<StockCenter, StockState> = .init()
    
    public init() {
        
    }
    
    public func setup() {
        
    }
}
