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
        
        //DEV:
//        sendEvent(
//            DashboardEvents.ShowDetail(
//                searchedStock: .init(
//                    exchangeName: "NASDAQ",
//                    symbolName: "MSFT",
//                    companyName: "Microsoft")))
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
	
    override public func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
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
