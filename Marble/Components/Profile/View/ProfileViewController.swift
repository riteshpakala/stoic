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
	
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    @objc
    func signInTapped(_ sender: UITapGestureRecognizer) {
        startSignInWithAppleFlow()
    }
}

extension ProfileViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow.init()
    }
    

    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
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
            
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                  // Error. If error.code == .MissingOrInvalidNonce, make sure
                  // you're sending the SHA256-hashed nonce as a hex string with
                  // your request to Apple.
                    print(error?.localizedDescription)
                    return
                }
            // User is signed in to Firebase with Apple.
            // ...
            }
        }
    }
    
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
      // 1
      let userData = UserData(email: credential.email!,
                              name: credential.fullName!,
                              identifier: credential.user)

      // 2
      let keychain = UserDataKeychain()
      do {
        try keychain.store(userData)
      } catch {
        //RITESH: sign in false
      }

      // 3
      do {
        let success = try WebApi.Register(user: userData,
                                          identityToken: credential.identityToken,
                                          authorizationCode: credential.authorizationCode)
         //RITESH: sign in true
      } catch {
         //RITESH: sign in false
      }
    }
    
    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
      // You *should* have a fully registered account here.  If you get back an error from your server
      // that the account doesn't exist, you can look in the keychain for the credentials and rerun setup

      // if (WebAPI.Login(credential.user, credential.identityToken, credential.authorizationCode)) {
      //   ...
      // }
       //RITESH: sign in true
    }

    private func signInWithUserAndPassword(credential: ASPasswordCredential) {
      // You *should* have a fully registered account here.  If you get back an error from your server
      // that the account doesn't exist, you can look in the keychain for the credentials and rerun setup

      // if (WebAPI.Login(credential.user, credential.password)) {
      //   ...
      // }
      //RITESH: sign in true
    }


    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error) {
        
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }

}

extension ProfileViewController {
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}
