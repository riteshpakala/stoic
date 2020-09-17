//
//  ProfileState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import CryptoKit

public class ProfileState: State {
    @objc dynamic var disclaimers: [Disclaimer]? = nil
    @objc dynamic var user: UserData? = nil
    @objc dynamic var subscription: Int = GlobalDefaults.Subscription.none.rawValue
    @objc dynamic var subscriptionUpdated: Bool = false
    var isRestoring: Bool = false
    var currentNonce: String?
    var recentPrediction: PredictionUpdate? = nil
    var intent: ProfileEvents.CheckCredential.Intent = .login
    
    @objc dynamic var userProperties: UserProperties? = nil
    
    public override init() {
        let nonce = ProfileState.randomNonceString()
        currentNonce = nonce
        super.init()
    }
}

extension ProfileState {
    private static func randomNonceString(length: Int = 32) -> String {
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
    
    public static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}
