//
//  NetworkRelayEvents.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct NetworkEvents {
    public struct User {
        public struct Get: GraniteEvent {
            let id: String
            public var beam: GraniteBeamType {
                .rebound
            }
            public struct Result: GraniteEvent {
                let user: NetworkServiceModels.User.Item?
                
                public var beam: GraniteBeamType {
                    .rebound
                }
            }
        }
        public struct Update: GraniteEvent {
            let id: String
            let email: String
            let username: String
            let intent: Intent
            
            public enum Intent {
                case signup
                case update
            }
            
            public var beam: GraniteBeamType {
                .rebound
            }
            
            public struct Result: GraniteEvent {
                let success: Bool
                
                public var beam: GraniteBeamType {
                    .rebound
                }
            }
        }
        public struct Apply: GraniteEvent {
            let email: String
            
            public var beam: GraniteBeamType {
                .rebound
            }
            
            public struct Result: GraniteEvent {
                let success: Bool
                
                public var beam: GraniteBeamType {
                    .rebound
                }
            }
        }
    }
}
