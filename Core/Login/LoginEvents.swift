//
//  LoginEvents.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

struct LoginEvents {
    public struct Auth: GraniteEvent {}
    public struct AuthComplete: GraniteEvent {
        let type: LoginType
    }
}
