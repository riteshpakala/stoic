//
//  Products.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/24/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Foundation
public struct StoicProducts {
    public static let monthlySub = "com.linenandsole.stoic.monthly.sub"
    public static let monthlySub3daytrial = "com.linenandsole.stoic.monthly.sub.trial3d"
    public static let store = IAPManager(productIDs: StoicProducts.productIDs)
    private static let productIDs: Set<ProductID> = [StoicProducts.monthlySub, StoicProducts.monthlySub3daytrial]
}

public func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
