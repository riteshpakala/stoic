//
//  SearchEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/7/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

struct SearchEvents {
    struct GetSearchResults: Event {
        let term: String
    }
}
