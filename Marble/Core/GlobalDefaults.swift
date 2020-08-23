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
    
    public static var defaults: [LocalStorage.Value<LocalStorageValue>] {
        return [
            LocalStorage.Value.init(Subscription.inActive),
            LocalStorage.Value.init(SentimentStrength.low),
            LocalStorage.Value.init(PredictionDays.seven),
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
        case inActive
        case active
        
        public var value: Int {
            return self.rawValue
        }
        
        public var asString: String {
            switch self {
            case .active: return "on"
            case .inActive: return "off"
            }
        }
        
        public var description: String {
            "account".lowercased().localized
        }
        
        public var resource: LocalStorageResource? {
            .image("profile.icon")
        }
    }
}
