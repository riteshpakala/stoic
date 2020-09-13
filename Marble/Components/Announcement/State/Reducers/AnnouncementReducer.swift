//
//  AnnouncementReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/13/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct AnnouncementReducer: Reducer {
    typealias ReducerEvent = AnnouncementEvents.Message
    typealias ReducerState = AnnouncementState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        
        switch event {
        case .welcome:
            let componentToPass = component
            component.service.center.backend.get(
                route: .announcementWelcome) { data in
                    
                    
                    guard let data = data.first else { return }
                    
                    let value = (data["value"] as? String) ?? "error"
                    let title = (data["title"] as? String) ?? "~"
                    let image = (data["image"] as? String) ?? ""
                    
                    let announcement: Announcement = .init(message: value, image: image, title: title)
                    
                    componentToPass.sendEvent(AnnouncementEvents.AnnouncementResponse.init(announcement))
            }
        case .upcoming:
            let componentToPass = component
            component.service.center.backend.get(
                route: .announcementUpcoming) { data in
                    
                    guard let data = data.first else { return }
                    
                    let value = (data["value"] as? String) ?? "error"
                    let title = (data["title"] as? String) ?? "~"
                    let image = (data["image"] as? String) ?? ""
                    let id = (data["id"] as? Int) ?? -1
                    
                    let announcement: Announcement = .init(message: value, id: id, image: image, title: title)
                    
                    componentToPass.sendEvent(AnnouncementEvents.AnnouncementResponse.init(announcement))
            }
        }
    }
}

struct AnnouncementResponseReducer: Reducer {
    typealias ReducerEvent = AnnouncementEvents.AnnouncementResponse
    typealias ReducerState = AnnouncementState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        state.announcement = event.announcement
    }
}
