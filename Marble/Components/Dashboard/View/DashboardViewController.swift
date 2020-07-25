//
//  DashboardViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

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
        
        sendEvent(
            DashboardEvents.ShowDetail(
                searchedStock: .init(
                    exchangeName: "NASDAQ",
                    symbolName: "MSFT",
                    companyName: "Microsoft")))
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
	
}
