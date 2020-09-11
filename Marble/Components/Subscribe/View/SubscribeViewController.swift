//
//  SubscribeViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 8/23/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit
import StoreKit
import Firebase

public class SubscribeViewController: GraniteViewController<SubscribeState> {
    override public func loadView() {
        self.view = SubscribeView.init()
    }
    
    public var _view: SubscribeView {
        return self.view as! SubscribeView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        observeState(
            \.disclaimers,
            handler: observeDisclaimers(_:),
            async: .main)
        
        observeState(
            \.products,
            handler: observeProducts(_:),
            async: .main)
        
        observeState(
            \.purchaseResult,
            handler: observePurchase(_:),
            async: .main)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        retrieveReceipt { info in
            self.verifySubscription(receipts: info) { items in
                if let items = items {
                    for key in items.keys {
                        guard let receipt = items[key] else { continue }
                        let purchaseResult = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable,
                            productId: key,
                            inReceipt: receipt)
                        
                        
                        
                        switch purchaseResult {
                        case .purchased(let date, let items):
                            print("{SUBSCRIBE} verify \(key)")
                        case .notPurchased:
                            break
                        case .expired(let expiryDate, let items):
                            break
                        }
                    }
                }
            }
        }
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

//MARK: Observers
extension SubscribeViewController {
    func observeDisclaimers(
        _ disclaimerChange: Change<[Disclaimer]?>) {
        guard  let disclaimers = disclaimerChange.newValue,
               let disclaimerCheck = disclaimers else {
            return
        }
        
        let labels: [(UILabel, String)] = disclaimerCheck.compactMap { ($0.label, $0.value) }
        
        _view.stackViewDisclaimers.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
            _view.stackViewDisclaimers.removeArrangedSubview(view)
        }
        
        for label in labels {
            label.0.text = label.1
            _view.stackViewDisclaimers.addArrangedSubview(label.0)
        }
        
        _view.stackViewDisclaimers.layoutIfNeeded()
    }
    
    func observeProducts(
        _ products: Change<[SKProduct]>) {
        
        guard let products = products.newValue else {
            return
        }
        
        _view.optionsLoadingLabel.isHidden = true
        _view.stackViewSubscriptionOptions.isHidden = false
        for product in products {
            let option = SubscriptionOption.init(product: product)
            _view.stackViewSubscriptionOptions.addArrangedSubview(option)
        }
    }
    
    func observePurchase(
        _ purchaseResult: Change<PurchaseResult?>) {
        
        guard let purchaseResultChange = purchaseResult.newValue,
              let result = purchaseResultChange else {
                print("{SUBSCRIBE} observed failed")
            return
        }
        
        print("{SUBSCRIBE} observed a \(result.success)")
        guard result.success else { return }
        
        handlePurchase(shouldUpload: true)
        
    }
    
    func handlePurchase(
        shouldUpload: Bool = false,
        completion: ((ReceiptInfo, URL) -> Void)? = nil) {
        guard let productID = component?.state.purchaseResult?.productID else { return }
        
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
                
            let request = SKReceiptRefreshRequest()
            request.delegate = self
            request.start()
            return
        }
        
        let appleValidator = AppleReceiptValidator(
            service: .sandbox,
            sharedSecret: StoicProducts.sharedSecret)
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { [weak self] result in
            switch result {
            case .success(let receipt):
                if shouldUpload {
                    self?.uploadReceipt(productID)
                }
                completion?(receipt, appStoreReceiptURL)
            case .error(let error):
                print("{SUBSCRIBE} could not verify \(error)")
            }
        }
    }
    
    func uploadReceipt(
        _ productID: ProductID) {
        
        guard let currentUser = Auth.auth().currentUser?.uid else { return }
        
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL else { return }

        do {
            let receiptData = try Data(contentsOf: appStoreReceiptURL)
            self.component?.service.center
                .backend
                .putData(
                receiptData,
                filename: productID,
                key: currentUser,
                storage: .subscription) { success in
                    
                    if success {
                        print("{SUBSCRIBE} uploaded successfully")
                    }
            }
        } catch let error {
            print("{SUBSCRIBE} \(error)")
        }
    }
    
    func retrieveReceipt(
        locally: Bool = false,
        completion: (([String:Data]) -> Void)? = nil) {
        
        var receipts: [String:Data] = [:]
        
        guard let currentUser = Auth.auth().currentUser?.uid else {
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
            }
        } else {
            self.component?.service.center
                .backend
                .getDataList(
                currentUser,
                storage: .subscription) { [weak self] (items, success) in
                    
                    if success {
                        for item in items {
                            self?.component?.service.center
                                .backend
                                .getData(fromRef: item) { data, success in
                                    if success, let data = data {
                                        receipts[item.name] = data
                                    }
                                    
                                    if receipts.count >= items.count {
                                        completion?(receipts)
                                    }
                            }
                        }
                        print("{SUBSCRIBE} downloaded successfully")
                    } else {
                        completion?(receipts)
                    }
            }
        }
    }
    
    func verifySubscription(
        receipts: [String: Data],
        completion: (([String: ReceiptInfo]?) -> Void)? = nil) {
        
        let appleValidator = AppleReceiptValidator(
            service: .sandbox,
            sharedSecret: StoicProducts.sharedSecret)
        
        var receiptInfo: [String: ReceiptInfo] = [:]
        for key in receipts.keys {
            guard let data = receipts[key] else { continue }
            appleValidator.validate(receiptData: data) { result in
                switch result {
                case .success(let receipt):
                    receiptInfo[key] = receipt
                    
                    if receiptInfo.count == receipts.values.count {
                        completion?(receiptInfo)
                    }
                default: completion?(nil); print("{SUBSCRIBE} could not verify")
                }
            }
        }
        
    }
}

extension SubscribeViewController: SKRequestDelegate {
    public func requestDidFinish(_ request: SKRequest) {
        print("{SUSBCRIBE} request did finish")
        handlePurchase(shouldUpload: true)
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("{SUBSCRIBE} \(error)")
    }
}
