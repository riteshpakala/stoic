//
//  Announcement.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/13/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation

public class Announcement: NSObject {
    let message: String
    let id: Int
    let image: String
    let title: String
    
    public init(message: String, id: Int = -1, image: String, title: String) {
        self.message = message
        self.id = id
        self.image = image
        self.title = title
    }
}
