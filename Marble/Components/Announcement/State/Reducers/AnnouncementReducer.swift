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
                    componentToPass.sendEvent(AnnouncementEvents.AnnouncementResponse.init(
                        disclaimers: data.compactMap {
                            if let message = $0["value"] as? String {
                                return message
                            } else {
                                return ""
                            }
                        }
                    ))
            }
        case .upcoming:
            let componentToPass = component
            component.service.center.backend.get(
                route: .announcementUpcoming) { data in
                    componentToPass.sendEvent(AnnouncementEvents.AnnouncementResponse.init(
                        disclaimers: data.compactMap {
                            print("{ANNOUNCEMENT} sent \($0)")
                            if let message = $0["value"] as? String {
                                return message
                            } else {
                                return ""
                            }
                        }
                    ))
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
        
        state.disclaimers = event.disclaimers
    }
}
