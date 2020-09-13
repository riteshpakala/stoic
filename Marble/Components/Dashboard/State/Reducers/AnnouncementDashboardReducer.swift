//
//  AnnouncementReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/13/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct AnnouncementDashboardReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.CheckAnnouncement
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let componentToPass = component
        
        let value = component.service.storage.get(GlobalDefaults.Announcement, defaultValue: -1)
        component.service.center.backend.get(
            route: .announcementUpcoming) { data in
                
                if let id = data.first?["id"] as? Int, id != value {
                    componentToPass.push(AnnouncementBuilder.build(
                        componentToPass.service,
                        state: .init(GlobalDefaults.Announcement)),
                        display: .modalTop)
                    print("{ANNOUNCEMENT} \(id)")
                }
        }
    }
}
