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
    @objc dynamic var announcement: Announcement? = nil
    var announcementKey: String?
    public init(_ announcementKey: String? = nil) {
        self.announcementKey = announcementKey
    }
}
