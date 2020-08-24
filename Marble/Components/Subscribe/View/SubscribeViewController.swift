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
}
