//
//  Router.Subscription.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/11/20.
//  Copyright © 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import Firebase

extension ServiceCenter {
    public enum SubscriptionStatus {
        case purchased
        case expired
        case notPurchased
    }
    
    public enum SubscriptionBenefits: String, CaseIterable {
        case liveSearch = "see live stock searches from other `Stoics`"
        case searchAnyStock = "search most stocks"
        case train12StocksSimul = "train up to 7 stocks at a time"
        case hiSentimentAccess = "access to `hi` sentiment strength"
        
        var isActive: Bool {
            switch self {
            case .liveSearch, .searchAnyStock, .train12StocksSimul, .hiSentimentAccess:
                return true
            }
        }
        
        var numerical: Int? {
            switch self {
            case .train12StocksSimul:
                return 8
            default:
                return nil
            }
        }
        
        var numericalAlt: Int? {
            switch self {
            case .train12StocksSimul:
                return 4
            default:
                return nil
            }
        }
        
        var alert: String {
            switch self {
            case .train12StocksSimul:
                return "you can only train up to 7 stocks at a time"
            default:
                return "unknown error"
            }
        }
        
        var alertAlt: String {
            switch self {
            case .train12StocksSimul:
                return "you must be a Stoic PRO in order to train more models at the same time"
            case .hiSentimentAccess:
                return "you must be a Stoic PRO in order to use `hi` sentiment strength"
            default:
                return "unknown error"
            }
        }
    }
    
    func requestSubscriptionUpdate(_ time: Double = 720) -> Bool {
        let value = storage.get(GlobalDefaults.SubscriptionCheck, defaultValue: 0.0)
        let elapsedTime = CFAbsoluteTimeGetCurrent() - value
        print("{SUBSCRIBE} requested \(elapsedTime)")
        if elapsedTime > time {
            updateSubscription()
            
            return true
        } else {
            return false
        }
        
    }//5 Minutes
    
    func updateSubscription() {
        storage.update(GlobalDefaults.SubscriptionCheck, CFAbsoluteTimeGetCurrent())
        self.checkSubscription { [weak self] subscription in
            if let value = subscription.values.first(where:  { $0 != .none } ), !subscription.isEmpty {
                self?.storage.update(value)
            } else {
                self?.storage.update(GlobalDefaults.Subscription.none)
            }
            
            DispatchQueue.main.async {
                if let delegate = UIApplication.shared.delegate as? GraniteAppDelegate {
                    delegate.coordinator.rootComponent.forwardEvent(ServiceCenter.Events.SubscriptionUpdated())
                }
            }
        }
    }
    
    
    func checkSubscription(completion: @escaping (([String: GlobalDefaults.Subscription]) -> Void)) {
        checkSubscriptionStatus { status in
            var subscription: [String: GlobalDefaults.Subscription] = [:]
            StoicProducts.productIDs.forEach { id in
                if let subStatus = status[id] {

                    switch id {
                    case StoicProducts.yearlySub:
                        subscription[StoicProducts.yearlySub] = subStatus == .purchased ? GlobalDefaults.Subscription.yearly : GlobalDefaults.Subscription.none
                    case StoicProducts.monthlySub:
                        subscription[StoicProducts.monthlySub] = subStatus == .purchased ? GlobalDefaults.Subscription.monthly : GlobalDefaults.Subscription.none
                    case StoicProducts.weeklySub:
                        subscription[StoicProducts.weeklySub] = subStatus == .purchased ? GlobalDefaults.Subscription.weekly : GlobalDefaults.Subscription.none
                    default:
                        subscription[identify(GlobalDefaults.Subscription.none)] = GlobalDefaults.Subscription.none
                        
                    }
                }
            }
            
            completion(subscription)
        }
    }
    
    func checkSubscriptionStatus(
        completion: @escaping (([String:ServiceCenter.SubscriptionStatus]) -> Void)) {
        
        var subStatus: [String: ServiceCenter.SubscriptionStatus] = [:]
        retrieveReceipt(productID: StoicProducts.yearlySub) { [weak self] infoYearly in
            self?.retrieveReceipt(productID: StoicProducts.monthlySub) { infoMonthly in
                self?.retrieveReceipt(productID: StoicProducts.weeklySub) { infoWeekly in
                    let info = infoYearly + infoMonthly + infoWeekly
                    guard !info.isEmpty else {
                        
                        completion(["":ServiceCenter.SubscriptionStatus.notPurchased])
                        return
                    }
                    self?.verifySubscription(receipts: info) { items in
                        if let items = items {
                            for key in items.keys {
                                
                                guard let receipt = items[key] else { continue }
                                print("{SUBSCRIBE} verifying ownership \(key)")
                                let purchaseResult = SwiftyStoreKit.verifySubscription(
                                    ofType: .autoRenewable,
                                    productId: key,
                                    inReceipt: receipt)
                                
                                
                                
                                switch purchaseResult {
                                case .purchased(let date, let items):
                                    subStatus[key] = .purchased
                                    print("{SUBSCRIBE} purchased \(key)")
                                case .notPurchased:
                                    subStatus[key] = .notPurchased
                                    print("{SUBSCRIBE} not purchased \(key)")
                                case .expired(let expiryDate, let items):
                                    subStatus[key] = .expired
                                    print("{SUBSCRIBE} expired \(key)")
                                }
                            }
                            completion(subStatus)
                        } else {
                            completion(subStatus)
                        }
                    }
                }
            }
        }
    }
    
    func retrieveReceipt(
        productID: String,
        locally: Bool = false,
        completion: (([String:Data]) -> Void)? = nil) {
        
        var receipts: [String:Data] = [:]
        
        guard let currentUser = Auth.auth().currentUser?.uid else {
            print("{SUBSCRIBE} no user detected")
            completion?(receipts)
            return
        }
        
        if locally {
            guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else {
                completion?(receipts)
                return
            }
            
            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL)
                completion?([appStoreReceiptURL.lastPathComponent : receiptData])
            } catch let error {
                completion?(receipts)
                print("{SUBSCRIBE} retrieval failed \(error)")
            }
        } else {
                self.backend
                .getDataList(
                currentUser+"/"+productID,
                storage: .subscription) { [weak self] (items, success) in
                    
                    guard items.count > 0, success else { completion?(receipts); return }
                    
                    self?.backend
                        .getData(
                        currentUser+"/"+productID,
                        filename: "\(items.count - 1)",
                        storage: .subscription) { data, success in
                            if success, let data = data {
                                receipts[productID] = data
                                

                                print("{SUBSCRIBE} downloaded successfully \(productID) \(items.count - 1)")
                            }
                            
                            completion?(receipts)
                    }
            }
        }
    }
    
    func verifySubscription(
        receipts: [String: Data],
        completion: (([String: ReceiptInfo]?) -> Void)? = nil) {
        
        let appleValidator = AppleReceiptValidator(
            service: .production,
            sharedSecret: StoicProducts.sharedSecret)
        
        var receiptInfo: [String: ReceiptInfo] = [:]
        var failed: Int = 0
        
        guard !receipts.isEmpty else {
            
            completion?(nil)
            return
        }
        
        for key in receipts.keys {
            guard let data = receipts[key] else { failed += 1; continue }
            appleValidator.validate(receiptData: data) { result in
                switch result {
                case .success(let receipt):
                    receiptInfo[key] = receipt
//                    print("{SUBSCRIBE} verified \(key)")
                    if receiptInfo.count == receipts.values.count {
                        completion?(receiptInfo)
                    }
                default: completion?(nil); print("{SUBSCRIBE} could not verify")
                }
            }
        }
        
        if failed >= receipts.count {
            completion?(nil)
        }
    }
}
