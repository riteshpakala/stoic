//
//  GLobalDefaults.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/22/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation



public struct GlobalDefaults {
    public static let subscription: String = "subscription"
    public static let predictionSentiment: String = "prediction.sentiment"
    public static let predictionDays: String = "prediction.days"
    
    public static var defaultKeys: [String] {
        return [
            GlobalDefaults.subscription,
            GlobalDefaults.predictionSentiment,
            GlobalDefaults.predictionDays]
    }
    
    
}
