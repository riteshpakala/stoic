//
//  ProfileViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit
import AuthenticationServices
import Firebase
import CryptoKit

public class ProfileViewController: GraniteViewController<ProfileState> {
    fileprivate var currentNonce: String?
    
    override public func loadView() {
        self.view = ProfileView.init()
    }
    
    public var _view: ProfileView {
        return self.view as! ProfileView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        _view.signInLabel.addGestureRecognizer(
            UITapGestureRecognizer.init(
                target: self,
                action: #selector(self.signInTapped(_:))))
        
        observeState(
            \.user,
            handler: observeUser(_:),
            async: .main)
        
        observeState(
            \.userProperties,
            handler: observeUserProperties(_:),
            async: .main)
        
        observeState(
            \.disclaimers,
            handler: observeDisclaimers(_:),
            async: .main)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc
    func signInTapped(_ sender: UITapGestureRecognizer) {
        sendEvent(ProfileEvents.CheckCredential(intent: .login))
    }
}

//MARK: Observers
extension ProfileViewController {
    func observeUser(
        _ user: Change<UserData?>) {
        
        guard let userChange = user.newValue,
              let user = userChange else {
            return
        }
        
        self._view.signInLabel.isHidden = true
        self._view.profileOverView.isHidden = false
    }
    
    func observeUserProperties(
        _ user: Change<UserProperties?>) {

        guard let userChange = user.newValue,
              let user = userChange,
                user.isPrepared else {
                    
            return
        }
        
        _view.profileOverView.setProperties(user)
    }
    
    func observeDisclaimers(
        _ disclaimerChange: Change<[Disclaimer]?>) {
        guard  let disclaimers = disclaimerChange.newValue,
               let disclaimerCheck = disclaimers else {
            return
        }
        
        let labels: [(UILabel, String)] = disclaimerCheck.compactMap { ($0.label, $0.value) }
        
        _view.profileOverView.stackViewDisclaimers.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
            _view.profileOverView.stackViewDisclaimers.removeArrangedSubview(view)
        }
        
        for label in labels {
            label.0.text = label.1
            _view.profileOverView.stackViewDisclaimers.addArrangedSubview(label.0)
        }
        
        _view.profileOverView.stackViewDisclaimers.layoutIfNeeded()
    }
}

//MARK: Apple Auth
extension ProfileViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow.init()
    }
    
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            sendEvent(ProfileEvents.Authenticate(credential: appleIDCredential))
            
        }
    }

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error) {
        
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
}
