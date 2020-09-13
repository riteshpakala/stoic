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
    
    var announcementKey: String {
        component?.state.announcementKey ?? (shouldWelcome ? GlobalDefaults.Welcome : GlobalDefaults.Announcement)
    }
    
    private lazy var agreeGesture: UITapGestureRecognizer = {
        .init(target: self, action: #selector(agreeTapped))
    }()
    
    private lazy var continueGesture: UITapGestureRecognizer = {
        .init(target: self, action: #selector(continueTapped))
    }()
    
    override public func loadView() {
        self.view = AnnouncementView.init()
    }
    
    public var _view: AnnouncementView {
        return self.view as! AnnouncementView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if shouldWelcome {
            self.isModalInPresentation = true
        }
        
        _view.thePrivacyAgree.label.addGestureRecognizer(agreeGesture)
        _view.theContinue.label.addGestureRecognizer(continueGesture)
        
        observeState(
            \.announcement,
            handler: observeAnnouncement(_:),
            async: .main)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if shouldWelcome {
            component?.service.storage.update(announcementKey, true)
        } else if let id = component?.state.announcement?.id {
            component?.service.storage.update(announcementKey, id)
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
	
    override public func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        if self.orientationIsIPhoneLandscape {
            if shouldWelcome {
                _view.updatePrivacyAppearance(landscape: true)
            } else {
                _view.updateAppearance(landscape: true)
            }
        } else if self.orientationIsIPhonePortrait {
            if shouldWelcome {
                _view.updatePrivacyAppearance(landscape: false)
            } else {
                _view.updateAppearance(landscape: false)
            }
        }
    }
    
    @objc
    func agreeTapped(_ sender: UITapGestureRecognizer) {
        component?.service.storage.update(announcementKey, true)
        self.component?.removeFromParent(animated: true)
    }
    
    @objc
    func continueTapped(_ sender: UITapGestureRecognizer) {
        if let id = component?.state.announcement?.id {
            component?.service.storage.update(announcementKey, id)
        }
        self.component?.removeFromParent(animated: true)
    }
}
//MARK: Observers
extension AnnouncementViewController {
    func observeAnnouncement(
        _ announcementChange: Change<Announcement?>) {
        
        guard let announcementValue = announcementChange.newValue, let announcement = announcementValue else { return }
        
        
        
        if let url = URL.init(string: announcement.image) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            
                            self?.showAnnouncement(announcement, image: image)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.showAnnouncement(announcement)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.showAnnouncement(announcement)
                    }
                }
            }
        } else {
            self.showAnnouncement(announcement)
        }
    }
    
    func showAnnouncement(_ announcement: Announcement, image: UIImage? = nil) {

        self._view.stopLoader()
        
        UIView.animate(withDuration: 0.25, animations: {
            self._view.setData(
                announcement: announcement,
                image: image,
                self.shouldWelcome)
        }, completion: { [weak self] finished in
            self?._view.setData(
                announcement: announcement,
                image: image,
                self?.shouldWelcome == true)
        })
    }
}
