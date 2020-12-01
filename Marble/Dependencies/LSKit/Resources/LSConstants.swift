//
//  Constants.swift
//  DeepCrop
//
//  Created by Ritesh Pakala on 7/10/18.
//  Copyright © 2018 Ritesh Pakala. All rights reserved.
//

import UIKit

struct LSConst {
    
    struct Colors {
        static var offWhite = UIColor(hex: "#FFFAFA")
        static var aTouchOfBlack = UIColor(hex: "#242424")
        static var aSpaceGray = UIColor(hex: "#C0C5CE")
        static var aDarkSpaceGray = UIColor(hex: "#A7ADBA")
        static var offBlack = UIColor(hex: "#121212")
        static var offGold = UIColor(hex: "#CFC882")
        static var antiqueGold = UIColor(hex: "#CFB53B")
        
        static var offWhite_Forced = UIColor(hex: "#FFFAFA")
        static var offBlack_Forced = UIColor(hex: "#121212")
    }
    
    struct Fonts {
        static let FiraSansLight : String = "FiraSans-Light"
        static let FiraSansMediumItalic : String = "FiraSans-MediumItalic"
        static let FiraSansMedium : String = "FiraSans-Medium"
        static let FiraSansBoldItalic : String = "FiraSans-BoldItalic"
        static let FiraSansBold : String = "FiraSans-Bold"
        static let FiraSansThinItalic : String = "FiraSans-ThinItalic"
        static let FiraSansThin : String = "FiraSans-Thin"
        static let FiraSansLightItalic : String = "FiraSans-LightItalic"
        static let FiraSansRegular : String = "FiraSans-Regular"
        static let FiraSansItalic : String = "FiraSans-Italic"
        static let FiraSansSemiBold : String = "FiraSans-SemiBold"
        static let FiraSansSemiBoldItalic : String = "FiraSans-SemiBoldItalic"
        
        static let PlayfairBoldItalic : String = "PlayfairDisplay-BoldItalic"
        static let PlayfairBold : String = "PlayfairDisplay-Bold"
        static let PlayfairBlackItalic : String = "PlayfairDisplay-BlackItalic"
        static let PlayfairBlack : String = "PlayfairDisplay-Black"
        static let PlayfairRegular : String = "PlayfairDisplay-Regular"
        static let PlayfairItalic : String = "PlayfairDisplay-Italic"
    }
    
    struct Filters {
        static let bw : String = "BlackAndWhite"
        static let sepia : String = "Sepia"
    }
    
    struct Styles {
        static let FiraSansPadding: CGFloat = 8.0
        static let PlayFairPadding: CGPoint = CGPoint(x: -10, y: 5)
    }
    
    struct General {
        static let displayName: String = "Marble"//"Linen & Sole"
        static let groupName: String = "group.com.linenandsole.wonder.main"
    }
    
    struct S3 {
        static let bucketName : String = "linenandsole-userfiles-mobilehub-1163119050"
        static let originalPath : String = "public/outfits/orig/"
        static let compositePath : String = "public/outfits/composite/"
        static let fileName : String = "/linenandsole.png"
    }
    
    struct DefaultKeys {
        static let lastVersion = "LastVersion"
        
        static let onboarding1Complete = "onboarding1Complete"
        static let onboarding2Complete = "onboarding2Complete"
        static let onboarding3Complete = "onboarding3Complete"
        static let defaultTimeline = "defaultTimeline"
        static let scheduledNotifications = "scheduledNotifications"
        static let exported = "exported"
        static let skinsExported = "skinsExported"
        
        static let onboardingComplete = "onboardingComplete"
        static let onboardingMain = "onboardingMain"
        static let onboardingControls = "onboardingControls"
        static let onboardingSkins = "onboardingSkins"
        static let onboardingSkins_2 = "onboardingSkins_2"
        static let onboardingCompose = "onboardingCompose"
        static let onboardingControlsComplete = "onboardingControlsComplete"
        static var onboardingSkinCreation = "onboardingSkinCreation"
        static let controlSwipeOnboardingComplete = "controlSwipeOnboardingComplete"
        static let onboardingExhibitionUpload = "onboardingExhibitionUpload"
        static let termsComplete = "termsComplete"
        static let userIsOffline = "userIsOffline"
        
        static let permissionsForCameraAndMicrophone = "permissionsForCameraAndMicrophone"
    }
    struct DeviceKeys {
        static let A4 = "A4"
        static let A5 = "A5"
        static let A6 = "A6"
        static let A7 = "A7"
        static let A8 = "A8"
        static let A9 = "A9"
        static let A10 = "A10 Fusion"
        static let superior = "Superior"
    }
    
    struct Audio {
        static let peek: UInt32 = 1519
        static let pop: UInt32 = 1520
        static let nope: UInt32 = 1521
    }
    
    struct Device {
        static var height : CGFloat {
            return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        }
        static var width : CGFloat {
            return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        }
        static var size : CGSize {
            return UIScreen.main.bounds.size
        }
        static var bounds : CGRect {
            return UIScreen.main.bounds
        }
        static var isIPhoneX : Bool {
            return max(width, height) <= 812
        }
        static var isIPhone6 : Bool {
            return max(width, height) <= 667
        }
        
        static var isIPhone6Plus : Bool {
            return max(width, height) <= 737
        }
        
        static var isIPhoneXMax : Bool {
            return max(width, height) >= 896
        }
        
        static var isIPhone : Bool {
            return UIDevice.current.userInterfaceIdiom == .phone
        }
        
        static var isIPad : Bool {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
        
        static var isLandscapeLeft : Bool {
            return UIDevice.current.orientation == .landscapeLeft
        }
        
        static var isLandscapeRight : Bool {
            return UIDevice.current.orientation == .landscapeRight
        }
        
        static var isPortrait : Bool {
            return UIDevice.current.orientation != .landscapeLeft || UIDevice.current.orientation != .landscapeRight
        }
        
        static var isDarkMode: Bool {
            if #available(iOS 12.0, *) {
                return UIScreen.main.traitCollection.userInterfaceStyle == .dark
            } else {
                return false
            }
        }
        
        static var isConnected : Bool = false
    }
    
    struct Error {
        
    }
    
    struct Notifications {
        static let RealmDidUpdate = NSNotification.Name(rawValue: "RealmDidUpdate")
    }
}

struct LSPhotoFeatures {
    static var sfw = "SFW"
    static var nsfw = "NSFW"
}

struct LSQuotes {
    static var list : [String] = ["\"Design can be art.\nDesign can be aesthetics.\nDesign is so simple, that's why\nit is so complicated.\"\n\nPaul Rand",
    "\"Design is not for philosophy\nit's for life.\"\n\nIssey Miyake", "\"Bad design is smoke,\nwhile good design is\na mirror\"\n\nJuan-Carlos Fer.","\"Design creates culture.\nCulture shapes values.\nValues determine the future\"\n\nRobert L. Peters", "\"Design is the intermediary\nbetween information\nand understanding\"\n\nHans Hoffman", "\"Design is not just what\nit looks like and feels like.\nDesign is how it works.\"\n\nSteve Jobs", "\"Color does not add a\npleasant quality to design\n- it reinforces it.\"\n\nPierre Bonnard", "\"Good design is obvious.\nGreat design is transparent.\"\n\nJoe Soprano", "\"Simplicity, carried to an\nextreme, becomes elegance.\"\n\nJohn Franklin", "\"Design is intelligence.\nmade visible.\"\n\nAlina Wheeler", "\"Creativity is to think\nmore efficiently.\"\n\nPierre Reverdy", "\"Perfection is achieved, not when there is\nnothing more to add, but when there is\nnothing left to take away.\"\n\nAntoine De Saint-Exupery", "\"Design is in everything we make,\nbut it's also between those things.\nIt's a mix of craft, science, storytelling,\npropaganda, and philosophy.\"\n\nErik Edigard"]
}

struct LSResources {
    
    static let closeSign = "\u{2715}"
    
}
