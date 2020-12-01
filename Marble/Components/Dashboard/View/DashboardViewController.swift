//
//  DashboardViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

public class DashboardViewController: GraniteViewController<DashboardState> {
    override public func loadView() {
        self.view = DashboardView.init()
    }
    
    public var _view: DashboardView {
        return self.view as! DashboardView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        _view.parent = self.parent?.view
        
        observeState(
            \.settingsDidUpdate,
            handler: observeSettingsDidUpdate(_:),
            async: .main)
        
        
//        Cryptowatcher().getMarketPrice(exchange: "coinbase-pro", pair: "btcusd").then { response in
//          let price = response.result.price
//          let remainingAllowance = response.allowance.remaining
//
//            print("{TEST 2} \(price)")
//          // Use the values to do something fun
//        }.onError { error in
//          // Handle the error
//            print("{TEST 2} \(error.localizedDescription)")
//        }
        //DEV:
//        guard let predictions = component?.service.center.getMergedStockModels(from: .main) else {
//            print("{CoreData} none found")
//            return
//        }
//        print("{CoreData} \(predictions.count)")
//
//        var stockModel: StockModel? = nil
//        let prediction = predictions[0]
////        if let prediction = predictions[1] {
//            print("{CoreData} \(prediction.models?.count)")
//
//            prediction.models?.forEach { model in
//                if let stockModel2 = model as? StockModelObject {
//                    stockModel = StockModel.init(from: stockModel2)
//                }
//
//            }
////            let model = StockModel.init(from: prediction)
////
//            if stockModel != nil {
//
//                sendEvent(DashboardEvents.ShowDetail.stored(stockModel!))
//            }
//        }
        ///////////// for the coreData logic above*
        //DEV:
//        sendEvent(DashboardEvents.ShowDetail.search(.init(
//            exchangeName: "NASDAQ",
//            symbolName: "SHOP",
//            companyName: "Shopify")))
        
        let vaderTestOutput = VaderSentiment.predict("What is it that makes so sticky? How durable are its competitive advantages? ")
        print("{TEST 4} \(vaderTestOutput.asString)")
        
        
        //DEV:
//        sendEvent(SubscribeEvents.Show())
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        _view.undim(animated: true)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _view.parent = nil
    }
	
    override public func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard self.isIPhone else { return }
        if UIDevice.current.orientation == .landscapeLeft {
            _view.settings.edge = .right
        } else {
            _view.settings.edge = .left
        }
        
    }
}

// MARK: Observers
extension DashboardViewController {
    func observeSettingsDidUpdate(
        _ updateRun: Change<Int>) {
        self._view.settings.settingsItems = component?.state.settingsItems ?? self._view.settings.settingsItems
    }
}
