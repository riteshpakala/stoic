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
    public enum AnnouncementDisplayType {
        case remote
        case alert(String)
    }
    
    @objc dynamic var announcement: Announcement? = nil
    var announcementKey: String?
    var displayType: AnnouncementDisplayType
    public init(_ announcementKey: String? = nil, displayType: AnnouncementDisplayType = .remote) {
        self.announcementKey = announcementKey
        self.displayType = displayType
    }
}
