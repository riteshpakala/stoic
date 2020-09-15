//
//  HomeViewEvents.swift
//  Marble
//
//  Created by Ritesh Pakala on 5/14/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

struct HomeEvents {
    public struct PresentAlertController: Event {
        let alert: UIAlertController
        public init(_ alert: UIAlertController) {
            self.alert = alert
        }
    }
    public struct PresentAlert: Event {
        let message: String
        public init(_ message: String) {
            self.message = message
        }
    }
}
