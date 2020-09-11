//
//  Products.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/24/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
public struct StoicProducts {
    public static let sharedSecret = "df879900bd6a47dfbec0b1f124ca4421"
    public static let weeklySub = "com.linenandsole.stoic.weekly.sub"
    public static let monthlySub = "com.linenandsole.stoic.monthly.sub"
    public static let yearlySub = "com.linenandsole.stoic.yearly.sub"
    public static let store = IAPManager(productIDs: StoicProducts.productIDs)
    private static let productIDs: Set<ProductID> = [StoicProducts.weeklySub, StoicProducts.monthlySub, StoicProducts.yearlySub]
}

public func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
