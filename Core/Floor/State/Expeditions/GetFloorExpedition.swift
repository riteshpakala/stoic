//
//  GetFloorExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 1/10/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct GetFloorExpedition: GraniteExpedition {
    typealias ExpeditionEvent = FloorEvents.Get
    typealias ExpeditionState = FloorState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        
        
        print("{TEST} heyyy")
        
        guard let portfolio = connection.retrieve(\EnvironmentDependency.user.portfolio),
              let floor = portfolio?.floor else {
            return
        }
        
        if floor.securities.isEmpty == true {
            var securities: [[Security?]] = []
            //
            var cols: [Int] = .init(repeating: 0, count: FloorConfig.maxWindows.width.asInt)
            cols = cols.enumerated().map { $0.offset }
            //

            for row in 0..<FloorConfig.maxWindows.height.asInt {
                var securitiesRow: [Security?] = []

                for col in cols {
                    securitiesRow.append(nil)
                }
                
                securities.append(securitiesRow)
            }

            state.activeSecurities = securities
        }
    }
}
