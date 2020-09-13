//
//  GLobalDefaults.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/22/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation

public struct GlobalDefaults: LocalStorageDefaults {
    public init() {}
    
    public static var allLSVDefaults: [LocalStorage.Value<LocalStorageValue>] {
        return GlobalDefaults.defaults
    }
    
    public static var allVariableDefaults: [LocalStorage.Value<Any>] {
        return GlobalDefaults.variableDefaults + GlobalDefaults.onboardingDefaults
    }
    
    public static var defaults: [LocalStorage.Value<LocalStorageValue>] {
        return [
            LocalStorage.Value.init(Subscription.none),
            LocalStorage.Value.init(Browser.none),
            LocalStorage.Value.init(SentimentStrength.low),
            LocalStorage.Value.init(PredictionDays.two),
        ]
    }
    
    public static var onboardingDefaults: [LocalStorage.Value<Any>] {
        return [
            LocalStorage.Value.init(GlobalDefaults.OnboardingDashboard, false),
            LocalStorage.Value.init(GlobalDefaults.OnboardingDetail, false),
            LocalStorage.Value.init(GlobalDefaults.OnboardingBrowser, false),
        ]
    }
    
    public static var variableDefaults: [LocalStorage.Value<Any>] {
        return [
            LocalStorage.Value.init(GlobalDefaults.SubscriptionCheck, CFAbsoluteTimeGetCurrent()),
        ]
    }

    public enum SentimentStrength: Int, LocalStorageValue {
        case low
        case med
        case hi
        
        public var value: Int {
            switch self {
            case .low: return 1
            case .med: return 4
            case .hi: return 7
            }
        }
        
        public var asString: String {
            switch self {
            case .low: return "low"
            case .med: return "med"
            case .hi: return "hi"
            }
        }
        
        public var description: String {
            "sentiment strength".lowercased().localized
        }
        
        public var permissions: LocalStorageReadWrite {
            return .readAndWrite
        }
    }
    
    public enum PredictionDays: Int, LocalStorageValue {
        
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case ten
        case eleven
        case twelve
        
        public var value: Int {
            return self.rawValue + 1
        }
        
        public var asString: String {
            return String(self.value)
        }
        
        public var description: String {
            "days to learn".lowercased().localized
        }
        
        public var permissions: LocalStorageReadWrite {
            return .readAndWrite
        }
    }
    
    public enum Subscription: Int, LocalStorageValue {
        case yearly
        case monthly
        case weekly
        case none
        
        public var value: Int {
            return self.rawValue
        }
        
        public var asString: String {
            self.isActive ? "on" : "off"
        }
        
        public var description: String {
            switch self {
            case .yearly, .monthly, .weekly:
                return "account // PRO".lowercased().localized
            case .none:
                return "account".lowercased().localized
            }
        }
        
        public var resource: LocalStorageResource? {
            .image("profile.icon")
        }
        
        public var isActive: Bool {
            return self != Subscription.none
        }
        
        public static func from(_ value: Int?) -> GlobalDefaults.Subscription {
            if let value = value {
                return GlobalDefaults.Subscription.init(rawValue: value) ?? GlobalDefaults.Subscription.none
            } else {
                return GlobalDefaults.Subscription.none
            }
        }
    }
    
    public static var SubscriptionCheck: String = "SubscriptionCheck"
    
    public enum Browser: Int, LocalStorageValue {
        case hasStaleModels
        case modelsNeedSync
        case hasNoModels
        case none
        
        public var value: Int {
            return self.rawValue
        }
        
        public var asString: String {
            switch self {
            case .modelsNeedSync: return "some models need to sync"
            case .hasStaleModels: return "you have stale models"
            case .hasNoModels: return "you don't have any models"
            case .none: return ""
            }
        }
        
        public var description: String {
            "model browser".lowercased().localized
        }
        
        public var resource: LocalStorageResource? {
            .image("browser.icon")
        }
    }
    
    //MARK: -- Onboarding Defaults
    public static var OnboardingDashboard: String = "OnboardingDashboard"
    public static var OnboardingDetail: String = "OnboardingDetail"
    public static var OnboardingBrowser: String = "OnboardingBrowser"
}
