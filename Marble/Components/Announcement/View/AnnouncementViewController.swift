//
//  AnnouncementViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 9/13/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//

import Granite
import Foundation
import UIKit

public class AnnouncementViewController: GraniteViewController<AnnouncementState> {
    
    var shouldWelcome: Bool {
        component?.service.center.welcomeCompleted == false
    }
    
    override public func loadView() {
        self.view = AnnouncementView.init()
    }
    
    public var _view: AnnouncementView {
        return self.view as! AnnouncementView
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
extension AnnouncementViewController {
    func observeDisclaimers(
        _ disclaimerChange: Change<[String]?>) {
        _view.stopLoader()
        
        _view.theMessage.text = disclaimerChange.newValue??.first

        _view.theMessage.isHidden = false
        
        if shouldWelcome {
            _view.thePrivacy.isHidden = false
            component?.service.storage.update(GlobalDefaults.Welcome, true)
        }
    }
}
