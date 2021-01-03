//
//  BootExpedition.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
import GraniteUI
import SwiftUI
import Combine

struct BootExpedition: GraniteExpedition {
    typealias ExpeditionEvent = EnvironmentEvents.Boot
    typealias ExpeditionState = EnvironmentState
    
    func reduce(
        event: ExpeditionEvent,
        state: ExpeditionState,
        connection: GraniteConnection,
        publisher: inout AnyPublisher<GraniteEvent, Never>) {
        let page: EnvironmentConfig.Page = state.config.kind.page
        
        var windows: [[WindowConfig]] = []
        
        //
        var cols: [Int] = .init(repeating: 0, count: page.windows.first?.count ?? state.maxWindows.width.asInt)
        cols = cols.enumerated().map { $0.offset }
        //
        
        for row in 0..<state.maxWindows.height.asInt {
            var windowRow: [WindowConfig] = []
            for col in cols {
                let config: WindowConfig = .init(kind: page.windows[row][col],
                                                 index:
                                                    .init(x: col,
                                                          y: row)
                                                 )
                
                windowRow.append(config)
            }
            windows.append(windowRow)
        }
        
        state.activeWindows = windows
    /*
         
         
         [ 0  0  0  0  0  0 ]
         [ 0  0  0  0  0  0 ]
         [ 0  0  0  0  0  0 ]
         
         
         */
        
    }
}
