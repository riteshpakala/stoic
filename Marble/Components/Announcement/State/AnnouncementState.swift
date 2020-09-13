//
//  AnnouncementState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/13/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

public class AnnouncementState: State {
    @objc dynamic var disclaimers: [String]? = nil
    var welcomeKey: String?
    public init(_ welcomeKey: String? = nil) {
        self.welcomeKey = welcomeKey
    }
}
