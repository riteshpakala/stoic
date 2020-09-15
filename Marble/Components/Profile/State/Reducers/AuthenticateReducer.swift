//
//  AuthReducerReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import Firebase
import CryptoKit

struct AuthenticateReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.Authenticate
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        guard let nonce = state.currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = event.credential.identityToken else {
            print("Unable to fetch identity token")
            return
        }
        
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }

        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
        
        
        let userData = UserData(
            email: event.credential.email ?? "error-email-\(UUID().uuidString)",
            name: event.credential.fullName ?? PersonNameComponents.init(),
            identifier: event.credential.user)

        do {
            try component.service.center.keychain.store(userData)
            print("{KEYCHAIN} Keychain storage success")
        } catch let error {
            print("{KEYCHAIN} Keychain storage failed \(error)")
        }
        
        let componentToPass = component
        // Sign in with Firebase.
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if (error != nil) {
                print(error?.localizedDescription ?? "error invalid")
                return
            }
            
            componentToPass.sendEvent(ProfileEvents.ProfileSetup())
        }
    }
}

struct SignOutReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.SignOut
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        do {
            try Auth.auth().signOut()
            
            sideEffects.append(.init(event: ProfileEvents.ProfileSetup()))
            
        } catch let error {
            print(error)
        }
        
    }
}
