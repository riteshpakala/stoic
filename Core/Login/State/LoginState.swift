//
//  LoginState.swift
//  stoic
//
//  Created by Ritesh Pakala on 2/1/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import GraniteUI
import SwiftUI
import Combine

public enum LoginStage {
    case signup
    case login
    case apply
    case none
    case experience
}

public class LoginState: GraniteState {
    var email: String = ""
    var password: String = ""
    var username: String = ""
    var code: String = ""
    
    var error: String? = nil
    var stage: LoginStage = .none
    var success: Bool = false
    
    var isReadyForApplying: Bool {
        email.isNotEmpty
    }
    
    var isReadyForLogin: Bool {
        isReadyForApplying && password.isNotEmpty
    }
    
    var isReadyForSignup: Bool {
        username.isNotEmpty && code.isNotEmpty && isReadyForLogin
    }
}

public class LoginCenter: GraniteCenter<LoginState> {
    let networkRelay: NetworkRelay = .init()
    
    public override var expeditions: [GraniteBaseExpedition] {
        [
            AuthExpedition.Discovery(),
            AuthResultExpedition.Discovery(),
            ApplyResultExpedition.Discovery(),
            AppleCodeResultExpedition.Discovery(),
            SignupResultExpedition.Discovery()
        ]
    }
}

public struct AuthValidator {
    public enum AuthValidatorType {
        case email
        case password
        case username
        case code
        case login
        case all
        case none
        
        var error: String {
            switch self {
            case .email:
                return "// invalid email entered"
            case .password:
                return
                    """
                    // a valid password needs:
                    - 1 or more uppercase letters
                    - 1 or more digits
                    - 1 or more lowercase letters
                    - 1 or more symbols
                    - minimum 8 characters
                    """
            case .username:
                return
                    """
                    // a valid username needs:
                    - NO special characters
                      - EXCEPT underscores `_`
                    - minimum 4 characters
                    - maximum 16 characters
                    """
            case .code:
                return "// invalid code entered"
            default:
                return ""
            }
        }
    }
    
    public static func email(_ text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: text)
    }
    
    public static func password(_ text: String) -> Bool {
        // least one uppercase,
        // least one digit
        // least one lowercase
        // least one symbol
        //  min 8 characters total
        let password = text.trimmingCharacters(in: CharacterSet.whitespaces)
        let passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{8,}$"
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
    }
    
    public static func username(_ text: String) -> Bool {
//        No special characters (e.g. @,#,$,%,&,*,(,),^,<,>,!,±)
//        Only letters, underscores and numbers allowed
//        Length should be 16 characters max and 4 characters minimum
        do
        {
            let regex = try NSRegularExpression(pattern: "^[0-9a-zA-Z\\_]{4,16}$", options: .caseInsensitive)
            if regex.matches(in: text,
                             options: [],
                             range: NSMakeRange(0, text.count)).count > 0 {return true}
        }
        catch {}
        return false
    }
}
