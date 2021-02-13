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
        
        if let stage = connection.retrieve(\EnvironmentDependency.holdingsFloor.floorStage) {
            state.floorStage = stage
        }
        
        guard let portfolio = connection.retrieve(\EnvironmentDependency.user.portfolio),
              let floors = portfolio?.floors else {
            empty(state)
            return
        }
        
        if floors.isEmpty {
            empty(state)
        } else {
            var securities: [[Security?]] = []
            var quotes: [[Quote?]] = []
            var cols: [Int] = .init(repeating: 0, count: FloorConfig.maxWindows.width.asInt)
            cols = cols.enumerated().map { $0.offset }
            //

            for row in 0..<FloorConfig.maxWindows.height.asInt {
                var securitiesRow: [Security?] = []
                var quotesRow: [Quote?] = []

                for col in cols {
                    let point: CGPoint = .init(row, col)
                    if let security = floors.first(where: { $0.location == point })?.security {
                        
                        securitiesRow.append(security)
                        
                        security.getQuote(moc: coreDataInstance) { quote in
                            quotesRow.append(quote)
                        }
                    } else {
                        securitiesRow.append(nil)
                        quotesRow.append(nil)
                    }
                }
                
                securities.append(securitiesRow)
                quotes.append(quotesRow)
            }
            
            state.activeSecurities = securities
            state.activeQuotes = quotes
        }
        
    }
    
    func empty(_ state: ExpeditionState) {
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
