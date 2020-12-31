//
//  ExperienceState.swift
//  * stoic
//
//  Created by Ritesh Pakala on 12/31/20.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public class ExperienceState: GraniteState {
    var isDesktop: Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
    
    var maxWindows: CGSize {
        isDesktop ? .init(4, 3) : .init(3, 4)//iPad can have 3, although mobile should be 1 width, mobile should also be scrollable the rest fixed
    }
    
    var activeWindows: [[WindowConfig]] = []
}

public class ExperienceCenter: GraniteCenter<ExperienceState> {
    public override var expeditions: [GraniteBaseExpedition] {
        [
            BootExpedition.Discovery(),
        ]
    }
    
    public var environmentMinSize: CGSize {
        return .init(
            CGFloat(state.activeWindows.count == 0 ?
                        Int(EnvironmentStyle.minWidth) :
                        state.activeWindows[0].count)*WindowStyle.minWidth,
            CGFloat(state.activeWindows.count)*WindowStyle.minHeight)
    }
    
    public var environmentMaxSize: CGSize {
        return .init(
            CGFloat(state.activeWindows.count == 0 ?
                        Int(EnvironmentStyle.minWidth) :
                        state.activeWindows[0].count)*WindowStyle.maxWidth,
            CGFloat(state.activeWindows.count)*WindowStyle.maxHeight)
    }
}
