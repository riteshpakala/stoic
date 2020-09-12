//
//  DashboardState.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation

public class DashboardState: State {
    var activeSearchedStocks: [String: SearchStock] = [:]
    var settingsItems: [TongueSettingsModel<LocalStorageValue>]? = nil
    @objc dynamic var settingsDidUpdate: Int = 12
    @objc dynamic var subscription: Int = GlobalDefaults.Subscription.none.rawValue
}
