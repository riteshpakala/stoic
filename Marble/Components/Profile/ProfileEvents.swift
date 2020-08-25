//
//  ProfileEvents.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import AuthenticationServices
import Foundation

struct ProfileEvents {
    public struct ShowSubscribe: Event {
    }
    public struct CheckCredential: Event {
        public enum Intent {
            case login
            case relogin
            case register
        }
        let intent: Intent
        public init(
            intent: CheckCredential.Intent) {
            self.intent = intent
        }
    }
    public struct Authenticate: Event {
        let credential: ASAuthorizationAppleIDCredential
    }
    
    public struct ProfileSetup: Event {}
    public struct ProfileSetupOverView: Event {
        let stockSearches: [SearchStock]
        let stockPredictions: [PredictionUpdate]
    }
    
    public struct GetDisclaimer: Event {}
    
    public struct GetDisclaimerResponse: Event {
        public let disclaimers: [Disclaimer]
    }
}
