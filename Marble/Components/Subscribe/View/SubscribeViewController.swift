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
            \.products,
            handler: observeProducts(_:),
            async: .main)
        
        observeState(
            \.purchaseResult,
            handler: observePurchase(_:),
            async: .main)
        
        observeState(
            \.isLoading,
            handler: observeIsLoading(_:),
            async: .main)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override public func willTransition(
        to newCollection: UITraitCollection,
        with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        if self.orientationIsIPhoneLandscape {
            _view.updateAppearance(landscape: true)
        } else if self.orientationIsIPhonePortrait {
            _view.updateAppearance(landscape: false)
        }
    }
}

//MARK: Observers
extension SubscribeViewController {
    
    func observeProducts(
        _ products: Change<[SKProduct]>) {
        
        guard let products = products.newValue else {
            return
        }
        
        _view.optionsLoadingLabel.isHidden = true
        _view.stackViewSubscriptionOptions.isHidden = false
        _view.updateLoaderAppearance(confirming: false)
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
    
    func observeIsLoading(
        _ isLoading: Change<Bool>) {
        
        guard let status = isLoading.newValue else {
            return
        }
        
        if status {
            _view.beginLoader()
        } else {
            _view.stopLoader()
        }
    }
}

extension SubscribeViewController: SKRequestDelegate {
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
            service: .production,
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
                .getDataList(currentUser+"/"+productID, storage: .subscription) { [weak self] items, error in
                        
               self?.component?.service.center
                   .backend
                   .putData(
                   receiptData,
                   filename: "\(items.count)",
                   key: currentUser+"/"+productID,
                   storage: .subscription) { success in
                       
                   if success {
                        print("{SUBSCRIBE} uploaded successfully")
                        DispatchQueue.main.async {
                            self?._view.updateLoaderAppearance(confirming: true)
                        }
                        self?.component?.service.center.updateSubscription()
                   }
               }
            }
               
        } catch let error {
            print("{SUBSCRIBE} \(error)")
        }
    }
    
    public func requestDidFinish(_ request: SKRequest) {
        print("{SUSBCRIBE} request did finish")
        handlePurchase(shouldUpload: true)
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("{SUBSCRIBE} \(error)")
    }
}
