//
//  ShowDetailReducer.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit

struct ShowDetailReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.ShowDetail
    typealias ReducerState = DashboardState
    
    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        let searchStock: SearchStock?
        let stockModel: StockModel?

        switch event {
        case .search(let stock):
            searchStock = stock
            stockModel = nil
        case .stored(let stored):
            searchStock = stored.searchStock
            stockModel = stored
        }
        
        if let browser = component.getSubComponent(BrowserComponent.self) {
            component.pop(browser, animated: true)
        }
        
        //Update settings options if a detail view was spawned
        //with changed preferences
        let settingsItem = GlobalDefaults.instance.writeableDefaults
        for item in settingsItem {
            if let index = state.settingsItems?.firstIndex(
                where: { $0.label == item.key }) {
                state.settingsItems?[index].reference = item
                state.settingsItems?[index].value = item.asString
            }
        }
        
        state.settingsDidUpdate = state.settingsDidUpdate % 12
        //
        
        guard state.activeSearchedStocks.values.first(
            where: { $0.symbolName == searchStock?.symbolName }) == nil else {
                
                state.activeSearchedStocks.forEach { (key, value) in
                    if value.symbolName == searchStock?.symbolName {
                        if let detailComponent = component
                            .getSubComponent(
                                DetailComponent.self,
                                id: key) {

                            DispatchQueue.main.async {
                                detailComponent.viewController?.view.shakeOnXAxis()
                            }
                        }
                    }
                }
                
                print("⛑ This stock is already active")
                return
        }
        
        //Subscription handling
        let isSubscribed = GlobalDefaults.Subscription.from(state.subscription).isActive
        if ServiceCenter.SubscriptionBenefits.train12StocksSimul.isActive {
            guard state.activeSearchedStocks.keys.count < (
                ServiceCenter.SubscriptionBenefits.train12StocksSimul.numericalAlt ?? 4) - 1 ||
            (isSubscribed && state.activeSearchedStocks.keys.count < (
            ServiceCenter.SubscriptionBenefits.train12StocksSimul.numerical ?? 8) - 1) else {
                if !isSubscribed {
                    sideEffects.append(
                        .init(
                            event: HomeEvents.PresentAlert.init(
                                ServiceCenter.SubscriptionBenefits.train12StocksSimul.alertAlt),
                            bubbles: true))
                } else {
                    sideEffects.append(
                        .init(
                            event: HomeEvents.PresentAlert.init(
                                ServiceCenter.SubscriptionBenefits.train12StocksSimul.alert),
                            bubbles: true))
                }
                return
            }
        }
        if ServiceCenter.SubscriptionBenefits.hiSentimentAccess.isActive {
            let hiSentiment = component.service.storage.getObject(GlobalDefaults.SentimentStrength.self)
            
            if hiSentiment?.value == GlobalDefaults.SentimentStrength.hi.value, !isSubscribed {
                sideEffects.append(
                    .init(
                        event: HomeEvents.PresentAlert.init(
                            ServiceCenter.SubscriptionBenefits.hiSentimentAccess.alertAlt),
                        bubbles: true))
                return
            }
        }
        //
        
        guard let stock = searchStock else {
            return
        }
        
        sideEffects.append(
            .init(
                event: SceneEvents.ChangeScene.init(
                    scene: .minimized),
                bubbles: true))
        
        let detailComponent = DetailBuilder.build(component.service, stock, stockModel)

        state.activeSearchedStocks[detailComponent.id] = stock
        
        component.push(detailComponent)
    }
}

struct DetailIsInteractingReducer: Reducer {
    typealias ReducerEvent = DashboardEvents.DetailIsInteracting
    typealias ReducerState = DashboardState

    func reduce(
        event: ReducerEvent,
        state: inout ReducerState,
        sideEffects: inout [EventBox],
        component: inout Component<ReducerState>) {
        
        if let detail = component.getSubComponent(id: event.id),
            let view = detail.viewController?.view {
            component.viewController?.view.bringSubviewToFront(view)
        }
    }
}

fileprivate enum Axis: StringLiteralType {
    case x = "x"
    case y = "y"
}

extension UIView {
    fileprivate func shake(on axis: Axis) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.\(axis.rawValue)")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20, 20, -20, 20, -10, 10, -5, 5, 0]
        animation.isRemovedOnCompletion = true
        layer.add(animation, forKey: "shake")
    }
    fileprivate func shakeOnXAxis() {
        self.shake(on: .x)
    }
    fileprivate func shakeOnYAxis() {
        self.shake(on: .y)
    }
}
