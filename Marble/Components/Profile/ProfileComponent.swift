//
//  ProfileComponent.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class ProfileComponent: Component<ProfileState> {
    override public var reducers: [AnyReducer] {
        [
            CheckCredentialStateReducer.Reducible(),
            AuthenticateReducer.Reducible(),
            ProfileSetupReducer.Reducible(),
            ProfileSetupOverViewReducer.Reducible(),
            ProfileDisclaimerReducer.Reducible(),
            ProfileDisclaimerResponseReducer.Reducible(),
//            ProfileSetupStockKitPreparedReducer.Reducible(),
//            ProfileGetCSVResultsResponseReducer.Reducible(),
            SubcriptionUpdatedProfileReducer.Reducible(),
            SignOutReducer.Reducible(),
            ProfileResetOnboardingReducer.Reducible(),
            SubcriptionRefreshProfileReducer.Reducible(),
        ]
    }
    
//    var stockKit: StockKitComponent? {
//        return getSubComponent(StockKitComponent.self) as? StockKitComponent
//    }
    
    override public func didLoad() {
//        push(
//            StockKitBuilder.build(
//            state: .init(
//                sentimentStrength: service.storage.get(
//                    GlobalDefaults.SentimentStrength.self),
//                predictionDays: service.storage.get(
//                    GlobalDefaults.PredictionDays.self)),
//            self.service))
        
        sendEvent(ProfileEvents.CheckCredential(intent: .relogin))
    }
}
