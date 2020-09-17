//
//  CheckCredentialStateReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import AuthenticationServices
import Security
import Firebase

struct CheckCredentialStateReducer: Reducer {
    typealias ReducerEvent = ProfileEvents.CheckCredential
    typealias ReducerState = ProfileState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
            
        guard let nonce = state.currentNonce else { return }
        state.intent = event.intent
        if event.intent == .login {
            let userData = try? component.service.center.keychain.retrieve()
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = ProfileState.sha256(nonce)
            
            let componentToPass = component
            if let user = userData?.identifier {
                appleIDProvider.getCredentialState(forUserID: user) { state, error in
                    switch state {
                        case .authorized:
                            let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                                            ASAuthorizationPasswordProvider().createRequest(),
                                            request]
                            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
                            authorizationController.delegate = componentToPass.viewController as? ProfileViewController
                            authorizationController.presentationContextProvider = componentToPass.viewController as? ProfileViewController
                            
                            authorizationController.performRequests()
                            // Credentials are valid.
                            break
                        case .revoked, .notFound, .transferred:
                            let requests = [request]
                            let authorizationController = ASAuthorizationController(authorizationRequests: requests)
                            authorizationController.delegate = componentToPass.viewController as? ProfileViewController
                            authorizationController.presentationContextProvider = componentToPass.viewController as? ProfileViewController
                            
                            authorizationController.performRequests()
                            //proceed signup
                            print("{PROFILE} proceed signup")
                        @unknown default:
                            break
                        }
                }
            }
            
            
        } else if event.intent == .relogin {
            do {
                let userData = try component.service.center.keychain.retrieve()
                
                print("{KEYCHAIN} Keychain retrieve success")
                
                let provider = ASAuthorizationAppleIDProvider()
                let componentToPass = component
                provider.getCredentialState(forUserID: userData.identifier) { state, error in
                    switch state {
                        case .authorized:
                            componentToPass.sendEvent(ProfileEvents.ProfileSetup())
                            // Credentials are valid.
                            break
                        case .revoked:
                            componentToPass.sendEvent(ProfileEvents.SignOut())
                            // Credential revoked, log them out
                        case .notFound:
                            componentToPass.sendEvent(ProfileEvents.SignOut())
                            // Credentials not found, show login UI
                        case .transferred:
                            componentToPass.sendEvent(ProfileEvents.SignOut())
                        @unknown default:
                            componentToPass.sendEvent(ProfileEvents.SignOut())
                            break
                        }
                }
            } catch let error {
                print("{KEYCHAIN} Keychain retrieve failed \(error.localizedDescription)")
            }
        }
    }
}
