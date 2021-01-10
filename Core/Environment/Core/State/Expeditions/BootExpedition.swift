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
        
        var windows: [[WindowComponent]] = []
        var windowsConfig: [[WindowConfig]] = []
        //
        var cols: [Int] = .init(repeating: 0, count: page.windows.first?.count ?? EnvironmentConfig.maxWindows.width.asInt)
        cols = cols.enumerated().map { $0.offset }
        //
        
        for row in 0..<EnvironmentConfig.maxWindows.height.asInt {
            var windowRowConfig: [WindowConfig] = []
            var windowRow: [WindowComponent] = []
            for col in cols {
                let config: WindowConfig = .init(kind: page.windows[row][col],
                                                 index:
                                                    .init(x: col,
                                                          y: row)
                                                 )
                
                windowRow.append(.init(state: .init(config)))
                windowRowConfig.append(config)
            }
            windows.append(windowRow)
            windowsConfig.append(windowRowConfig)
        }
        
        state.activeWindowConfigs = windowsConfig
        state.activeWindows = windows
        print("🪟🪟🪟🪟🪟🪟\nsetup windows for Environment - \(state.config.kind)\n\(state.activeWindows.flatMap { $0 }.count) windows total\n🪟")
    /*
         
         
         [ 0  0  0  0  0  0 ]
         [ 0  0  0  0  0  0 ]
         [ 0  0  0  0  0  0 ]
         
         
         */
        
    }
}
