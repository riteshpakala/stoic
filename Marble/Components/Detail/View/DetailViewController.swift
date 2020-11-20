//
//  DetailViewController.swift
//  Stoic
//
//  Created by Ritesh Pakala on 6/1/20.
//  Copyright (c) 2020 Ritesh Pakala. All rights reserved.
//
import Granite
import Foundation
import UIKit
import SwiftUI

public class DetailViewController: GraniteViewController<DetailState> {
    
    lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(
        target: self,
        action: #selector(self.longPressGesture(_:)))
        gesture.minimumPressDuration = 0.12
        return gesture
    }()
    
    override public func loadView() {
        self.view = DetailView.init()
    }
    
    public var _view: DetailView {
        return self.view as! DetailView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        _view.consoleView.setTitle(component?.state.searchedStock.symbol)
        
        _view.consoleView.taskbarView.addGestureRecognizer(longPressGesture)
        
        _view.consoleView.minimizeButton.addTarget(
            self,
            action: #selector(self.minimizeButtonTapped),
            for: .touchUpInside)
        
        _view.consoleView.closeButton.addTarget(
            self,
            action: #selector(self.closeButtonTapped),
            for: .touchUpInside)
        
        
        _view.consoleView.detailView.updatePage(RobinhoodPage.create(from: self))
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override public func viewDidLayoutSubviews() {
        
        if !isLaidOut {
            if let view = self._view.superview {
                self._view.center = .init(
                    x: view.bounds.width/2,
                    y: view.bounds.height/2)
            } else {
                self._view.center = .init(
                    x: UIScreen.main.bounds.width/2,
                    y: UIScreen.main.bounds.height/2)
            }
        }
        
        super.viewDidLayoutSubviews()
    }
	
    override public func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let origin = _view.frame.origin
        
        _view.frame.origin = .init(x: origin.y, y: origin.x)
        
    }
    
    override public func bind(_ component: Component<DetailState>) {
        super.bind(component)
        
        observeState(
            \.newTranslation,
            handler: observeTranslation(_:),
            async: .main)
        
        observeState(
            \.thinkPayload,
            handler: observeThink(_:),
            async: .main)
        
        observeState(
            \.progressLabelText,
            handler: observeProgressText(_:),
            async: .main)
        
        observeState(
            \.predictionState,
            handler: observeStockPredictionState(_:),
            async: .main)
    }
}

// MARK: Observers
extension DetailViewController {
    func observeTranslation(
        _ point: Change<CGPoint>) {
        
        let newCenter: CGPoint = .init(
                            x: self._view.center.x + (point.newValue?.x ?? 0),
                            y: self._view.center.y + (point.newValue?.y ?? 0))
                            
        guard newCenter.x - _view.frame.size.width/2 > -_view.frame.size.width/2 &&
              newCenter.y - _view.frame.size.height/2 > -_view.frame.size.height/2 &&
              newCenter.x < UIScreen.main.bounds.width &&
              newCenter.y < UIScreen.main.bounds.height  else {
            return
        }
        self._view.center = newCenter
    }
    
    func observeThink(
        _ payload: Change<ThinkPayload?>) {
        
        if  _view.currentState == .done {
            _view.consoleView.setThinkData(payload.newValue ?? nil)
        }
    }
    
    func observeProgressText(
        _ text: Change<String?>) {
        _view.consoleView.progressView.text = text.newValue ?? nil
    }
    
    func observeStockPredictionState(
        _ state: Change<String>) {
        
        guard let predictionState = DetailView.DetailPredictionState.init(
            rawValue: state.newValue ?? "") else {
            _view.currentState = .done
            return
        }
        
        _view.currentState = predictionState
        
        if  predictionState == .done,
            let payload = component?.state.consoleDetailPayload {
            _view.consoleView.setDetailData(payload)
        }
    }
    
    @objc
    func minimizeButtonTapped(_ sender: UIButton) {
        self.feedbackGenerator.prepare()
        
        if sender.tag == 0 {
            
            self._view.frame.size = _view.consoleView.minimizedTaskBarSize()
        } else if sender.tag == 1 {

            self._view.frame.size = _view.currentState == .done ? DetailStyle.consoleSizeExpanded : DetailStyle.consoleSizePredicting
        }
        
        _view.consoleView.changeViewState()
        
        self.feedbackGenerator.impactOccurred()
    }
    
    
    @objc
    func closeButtonTapped(_ sender: UIButton) {
        
        guard let searchedStock = component?.state.searchedStock else {
            return
        }
        self.feedbackGenerator.prepare()
        
        bubbleEvent(
            DashboardEvents.CloseDetail(
                id: component?.id,
                searchedStock: searchedStock))
        
        self.feedbackGenerator.impactOccurred()
    }
}

extension DetailViewController {
    @objc
    func longPressGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            sendEvent(DetailEvents.DetailLongPressStarted(
                translation: gestureRecognizer.location(
                    in: self._view.superview ?? self._view)))
        case .changed:
            sendEvent(DetailEvents.DetailLongPressChanged(
                translation: gestureRecognizer.location(
                    in: self._view.superview ?? self._view)))
        case .ended:
            sendEvent(DetailEvents.DetailLongPressEnded())
        default:
            break
        }
    }
}
